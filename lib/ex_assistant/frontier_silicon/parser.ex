defmodule FrontierSilicon.Parser do
  import SweetXml
  def postprocess_response(value, :array, _item), do: Base.decode16!(String.upcase(value))

  def postprocess_response(value, _, "netRemote.sys.net.ipConfig." <> item) when item != "dhcp",
    do: int_to_ip(value)

  def postprocess_response(value, _, _), do: value

  def parse_value(response) do
    xpath = get_xpath_by_type(response)
    xpath(response, xpath)
  end

  def get_response_status(response) do
    case xpath(response, ~x"/fsapiResponse/status/text()"s) do
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
    [
      div(ip_int, 16_777_216),
      rem(div(ip_int, 65536), 256),
      rem(div(ip_int, 256), 256),
      rem(ip_int, 256)
    ]
    |> Enum.join(".")
  end
  def get_session_id(body) do
    xpath(body, ~x"/fsapiResponse/sessionId/text()"s)
  end

  def parse_connect(body) do
    %{
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
          case type do
            :c8_array -> Map.put(acc, key, value)
            :array -> Base.decode16!(String.upcase(value))
            _ -> Map.put(acc, key, String.to_integer(value))
          end
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
end