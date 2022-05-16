defmodule ExFrontierSilicon.Parser do
  import SweetXml
  alias ExFrontierSilicon.Conn
  def postprocess_response(value, :array, _item), do: Base.decode16!(String.upcase(value))

  def postprocess_response(value, _, "netRemote.sys.net.ipConfig." <> item) when item != "dhcp",
    do: int_to_ip(value)

  def postprocess_response(value, _, _), do: value

  def parse_value(response) do
    xpath = get_xpath_by_type(response)
    xpath(response, xpath)
  end

  def get_response_status(response) do
    status = xpath(response, ~x"/fsapiResponse/status/text()"s)
    get_status(status)
  end

  def get_status(status) do
    case status do
      "FS_OK" -> :ok
      "FS_FAIL" -> {:error, :fail}
      "FS_PACKET_BAD" -> {:error, :bad_packet}
      "FS_NODE_DOES_NOT_EXIST" -> {:error, :not_exist}
      "FS_NODE_BLOCKED" -> {:error, :blocked}
      "FS_TIMEOUT" -> {:error, :timeout}
      "FS_LIST_END" -> {:error, :list_end}
    end
  end

  def get_response_type(response) do
    response
    |> xpath(~x"./*")
    |> elem(1)
  end

  defp get_xpath_by_type(response) do
    case get_response_type(response) do
      :u8 -> ~x"./u8/text()"i
      :u16 -> ~x"./u16/text()"i
      :u32 -> ~x"./u32/text()"i
      :s8 -> ~x"./s8/text()"i
      :s16 -> ~x"./s16/text()"i
      :s32 -> ~x"./s32/text()"i
      :c8_array -> ~x"./c8_array/text()"s
      :array -> ~x"./array/text()"s
      _ -> IO.inspect(response, label: :unsupported_response)
    end
  end

  def int_to_ip(ip_int) do
    0..3
    |> Enum.map(&rem(div(ip_int, floor(:math.pow(256, &1))), 256))
    |> Enum.reverse()
    |> Enum.join(".")
  end

  def get_session_id(body) do
    xpath(body, ~x"/fsapiResponse/sessionId/text()"s)
  end

  def parse_connect(body) do
    %Conn{
      friendly_name: xpath(body, ~x"/netRemote/friendlyName/text()"s),
      version: xpath(body, ~x"/netRemote/version/text()"s),
      webfsapi: xpath(body, ~x"/netRemote/webfsapi/text()"s)
    }
  end

  def parse_list(response) do
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
      )

    parsed_list =
      Enum.map(
        items,
        &Enum.reduce(&1.fields, %{"key" => &1.key}, fn %{key: key, value: value, type: type},
                                                       acc ->
          Map.put(acc, key, parse_by_type(value, type))
        end)
      )

    {:ok, parsed_list}
  end

  def parse_response(response) do
    {:ok,
     response
     |> xpath(~x"/fsapiResponse/value")
     |> parse_value()}
  end

  def parse_get_multiple(response) do
    %{items: items} =
      response
      |> xmap(
        items: [
          ~x"/fsapiGetMultipleResponse/fsapiResponse"l,
          key: ~x"./node/text()"s,
          status: ~x"./status/text()"s |> transform_by(&get_status/1),
          value: ~x"./value/*[1]/text()"S,
          type: ~x"./value/*"o |> transform_by(&maybe_get_type/1)
        ]
      )

    parsed_items =
      Enum.reduce(items, %{}, fn
        %{key: key, value: value, type: type, status: status}, acc ->
          case status do
            :ok -> Map.put(acc, key, parse_by_type(value, type))
            error -> Map.put(acc, key, error)
          end

        %{key: key, status: status}, acc ->
          Map.put(acc, key, status)
      end)

    {:ok, parsed_items}
  end

  def parse_get_notifies(response) do
    %{items: items, status: status} =
      response
      |> xmap(
        status: ~x"/fsapiResponse/status/text()"s |> transform_by(&get_status/1),
        items: [
          ~x"/fsapiResponse/notify"l,
          key: ~x"./@node"s,
          value: ~x"./value/*[1]/text()"S,
          type: ~x"./value/*"o |> transform_by(&maybe_get_type/1)
        ]
      )

    case status do
      :ok ->
        {:ok,
         Enum.reduce(items, %{}, fn %{key: key, value: value, type: type}, acc ->
           Map.put(acc, key, parse_by_type(value, type))
         end)}

      error ->
        error
    end
  end

  defp parse_by_type(value, type) do
    case type do
      :c8_array -> value
      :array -> Base.decode16!(String.upcase(value))
      _ -> String.to_integer(value)
    end
  end

  defp maybe_get_type({:xmlElement, element, _, _, _, _, _, _, _, _, _, _}), do: element
  defp maybe_get_type(_), do: nil
end
