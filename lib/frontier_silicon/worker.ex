defmodule FrontierSilicon.Worker do
  use Tesla
  import SweetXml

  @play_states %{
    0 => :stopped,
    1 => :unknown,
    2 => :playing,
    3 => :paused
  }
  @url "http://192.168.1.151:80/device"
  @pin 1234

  plug Tesla.Middleware.JSON

  def connect do
    {:ok, %{body: body}} = get(@url)

    body
    |> parse_connect()
    |> append_session()
  end

  defp parse_connect(body) do
    %{
      friendly_name: xpath(body, ~x"/netRemote/friendlyName/text()"s),
      version: xpath(body, ~x"/netRemote/version/text()"s),
      webfsapi: xpath(body, ~x"/netRemote/webfsapi/text()"s)
    }
  end

  def append_session(conn) do
    {:ok, %{body: body}} =
      conn.webfsapi
      |> Kernel.<>("/CREATE_SESSION")
      |> Kernel.<>("?" <> URI.encode_query(%{pin: @pin}))
      |> get()

    Map.put(conn, :session_id, xpath(body, ~x"/fsapiResponse/sessionId/text()"s))
  end

  def get_play_info_name(conn) do
    handle_text(conn, "netRemote.play.info.name")
  end

  def get_play_info_text(conn) do
    handle_text(conn, "netRemote.play.info.text")
  end

  def get_play_info_artist(conn) do
    handle_text(conn, "netRemote.play.info.artist")
  end

  def get_play_info_album(conn) do
    handle_text(conn, "netRemote.play.info.album")
  end

  def get_play_info_graphics(conn) do
    handle_text(conn, "netRemote.play.info.graphicUri")
  end

  def get_volume_steps(conn) do
    handle_int(conn, "netRemote.sys.caps.volumeSteps")
  end

  def get_play_status(conn) do
    status = handle_int(conn, "netRemote.play.status")
    @play_states[status]
  end

  def get_volume(conn) do
    handle_int(conn, "netRemote.sys.audio.volume")
  end

  def get_mute(conn) do
    handle_int(conn, "netRemote.sys.audio.mute")
  end

  def get_power(conn) do
    handle_int(conn, "netRemote.sys.power")
  end

  def get_friendly_name(conn) do
    handle_text(conn, "netRemote.sys.info.friendlyName")
  end

  def get_duration(conn) do
    with duration when is_integer(duration) <-
           handle_long(conn, "netRemote.play.info.duration") do
      Time.add(~T[00:00:00], duration, :millisecond)
    end
  end

  def get_mode(conn) do
    mode = handle_long(conn, "netRemote.sys.mode")
    Enum.find(get_modes(conn), fn %{key: key} -> key == mode end)
  end

  def get_modes(conn) do
    handle_list(conn, "netRemote.sys.caps.validModes")
    |> xpath(~x"/fsapiResponse/item"l)
    |> Enum.map(fn item ->
      xmap(item,
        key: ~x"/item/@key"i,
        id: ~x"/item/field[@name=\"id\"]/c8_array/text()"s,
        label: ~x"/item/field[@name=\"label\"]/c8_array/text()"s,
        selectable: ~x"/item/field[@name=\"selectable\"]/u8/text()"i,
        streamable: ~x"/item/field[@name=\"streamable\"]/u8/text()"i,
        modetype: ~x"/item/field[@name=\"modetype\"]/u8/text()"i
      )
    end)
  end

  def disconnect(conn) do
    doc = call(conn, "DELETE_SESSION")

    case xpath(doc, ~x"/fsapiResponse/status/text()"s) do
      "FS_OK" -> :ok
      _ -> :error
    end
  end

  def play(conn) do
    play_control(conn, 1)
  end

  def pause(conn) do
    play_control(conn, 2)
  end

  def forward(conn) do
    play_control(conn, 3)
  end

  def rewind(conn) do
    play_control(conn, 4)
  end

  def play_control(conn, value) do
    handle_set(conn, "netRemote.play.control", value)
  end

  def set_volume(conn, value) do
    handle_set(conn, "netRemote.sys.audio.volume", value)
  end

  def set_friendly_name(conn, value) do
    handle_set(conn, "netRemote.sys.info.friendlyName", value)
  end

  def set_mute(conn, value) do
    handle_set(conn, "netRemote.sys.audio.mute", value)
  end

  def set_power(conn, value) do
    handle_set(conn, "netRemote.sys.power", value)
  end

  def set_mode(conn, mode) do
    handle_set(conn, "netRemote.sys.mode", mode)
  end

  def handle_list(conn, item) do
    call(conn, "LIST_GET_NEXT/#{item}/-1", %{"maxItems" => 100})
  end

  def handle_text(conn, item) do
    conn
    |> handle_get(item)
    |> xpath(~x"/fsapiResponse/value/c8_array/text()"s)
  end

  def handle_int(conn, item) do
    conn
    |> handle_get(item)
    |> xpath(~x"/fsapiResponse/value/u8/text()"i)
  end

  def handle_long(conn, item) do
    conn
    |> handle_get(item)
    |> xpath(~x"/fsapiResponse/value/u32/text()"i)
  end

  def handle_get(conn, item) do
    call(conn, "GET/#{item}")
  end

  def handle_set(conn, item, true), do: handle_set(conn, item, 1)
  def handle_set(conn, item, false), do: handle_set(conn, item, 0)
  def handle_set(conn, item, value) do
    doc = call(conn, "SET/#{item}", %{value: value})

    case xpath(doc, ~x"/fsapiResponse/status/text()"s) do
      "FS_OK" -> :ok
      _ -> 
        IO.inspect(doc)
        :error
    end
  end

  def call(conn, path, params \\ %{}) do
    query_params = URI.encode_query(Map.merge(%{sid: conn.session_id, pin: @pin}, params))

    {:ok, %{body: body}} =
      conn.webfsapi
      |> Kernel.<>("/" <> path)
      |> Kernel.<>("?" <> query_params)
      |> get()

    body
  end
end
