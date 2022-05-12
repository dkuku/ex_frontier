defmodule FrontierSilicon.Worker do
  use Tesla
  import SweetXml
  alias FrontierSilicon.Constants

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
    handle_get(conn, "netRemote.play.info.name")
  end

  def get_play_info_text(conn) do
    handle_get(conn, "netRemote.play.info.text")
  end

  def get_play_info_artist(conn) do
    handle_get(conn, "netRemote.play.info.artist")
  end

  def get_play_info_album(conn) do
    handle_get(conn, "netRemote.play.info.album")
  end

  def get_play_info_graphics(conn) do
    handle_get(conn, "netRemote.play.info.graphicUri")
  end

  def get_volume_steps(conn) do
    handle_get(conn, "netRemote.sys.caps.volumeSteps")
  end

  def get_play_status(conn) do
    status = handle_get(conn, "netRemote.play.status")
    @net_remoet_play_states[status]
  end

  def get_volume(conn) do
    handle_get(conn, "netRemote.sys.audio.volume")
  end

  def get_mute(conn) do
    handle_get(conn, "netRemote.sys.audio.mute")
  end

  def get_power(conn) do
    handle_get(conn, "netRemote.sys.power")
  end

  def get_friendly_name(conn) do
    handle_get(conn, "netRemote.sys.info.friendlyName")
  end

  def get_duration(conn) do
    with duration when is_integer(duration) <-
           handle_get(conn, "netRemote.play.info.duration") do
      Time.add(~T[00:00:00], duration, :millisecond)
    end
  end

  def get_mode(conn) do
    mode = handle_get(conn, "netRemote.sys.mode")
    Enum.find(get_modes(conn), fn %{key: key} -> key == mode end)
  end

  def get_eq_modes(conn) do
    handle_list(conn, "netRemote.sys.caps.eqPresets")
  end

  def get_wifi_scan(conn) do
    handle_list(conn, "netRemote.sys.net.wlan.scanList")
  end

  def get_modes(conn) do
    handle_list(conn, "netRemote.sys.caps.validModes")
  end

  def disconnect(conn) do
    response = call(conn, "DELETE_SESSION")

    Constants.get_response_status(response)
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
    with response = call(conn, "LIST_GET_NEXT/#{item}/-1", %{"maxItems" => 100}),
         :ok <- Constants.get_response_status(response),
         %{items: items} =
           xmap(response,
             items: [
               ~x"/fsapiResponse/item"l,
               key: ~x"./@key"i,
               fields: [
                 ~x"./field"l,
                 key: ~x"./@name"s,
                 value: ~x"./*[1]/text()"s,
                 type: ~x"./*" |> transform_by(&elem(&1, 1))
               ]
             ]
           ) do
      Enum.map(
        items,
        &Enum.reduce(&1.fields, %{"key" => &1.key}, fn %{key: key, value: value}, acc ->
          Map.put(acc, key, value)
        end)
      )
    else
      {:error, error} -> error
    end
  end

  def handle_get(conn, item) do
    with response = call(conn, "GET/#{item}"),
         :ok <- Constants.get_response_status(response),
         type = Constants.get_response_type(response),
         raw_value = Constants.parse_response(response, type),
         value = Constants.postprocess_response(raw_value, type, item) do
      value
    else
      {:error, error} -> error
    end
  end

  def handle_set(conn, item, true), do: handle_set(conn, item, 1)
  def handle_set(conn, item, false), do: handle_set(conn, item, 0)

  def handle_set(conn, item, value) do
    response = call(conn, "SET/#{item}", %{value: value})

    case Constants.get_response_status(response) do
      :ok ->
        :ok

      {:error, error} ->
        IO.inspect(response)
        error
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
