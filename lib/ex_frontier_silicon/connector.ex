defmodule ExFrontierSilicon.Connector do
  use Tesla
  alias ExFrontierSilicon.Parser

  def connect do
    {:ok, %{body: body}} = get(hostname())

    body
    |> Parser.parse_connect()
    |> append_session()
  end

  defp append_session(conn) do
    session_id =
      conn
      |> call("CREATE_SESSION", pin: pin())
      |> Parser.get_session_id()

    Map.put(conn, :session_id, session_id)
  end

  def disconnect(conn) do
    response = call(conn, "DELETE_SESSION")

    Parser.get_response_status(response)
  end

  def handle_list(conn, item) do
    with response <- call(conn, "LIST_GET_NEXT/#{item}/-1", maxItems: 100),
         :ok <- Parser.get_response_status(response),
         {:ok, list} <- Parser.parse_list(response) do
      list
    else
      {:error, error} -> error
    end
  end

  def handle_get(conn, item) do
    with response <- call(conn, "GET/#{item}"),
         :ok <- Parser.get_response_status(response),
         type = Parser.get_response_type(response),
         {:ok, raw_value} <- Parser.parse_response(response) do
      Parser.postprocess_response(raw_value, type, item)
    else
      {:error, error} -> error
    end
  end

  def handle_get_multiple(conn, items) do
    if Enum.count_until(items, max_get_multiple_count() + 1) <= max_get_multiple_count() do
      params = Enum.map(items, &{:node, &1})

      conn
      |> call("GET_MULTIPLE", params)
      |> Parser.parse_get_multiple()
    else
      {:error, :too_many_values_requested}
    end
  end

  def handle_get_notifies(conn) do
    case call(conn, "GET_NOTIFIES", sid: conn.session_id) do
      {:error, :timeout} = e -> e
      res -> Parser.parse_get_notifies(res)
    end
  end

  def handle_set(conn, item, true), do: handle_set(conn, item, 1)
  def handle_set(conn, item, false), do: handle_set(conn, item, 0)

  def handle_set(conn, item, value) do
    response = call(conn, "SET/#{item}", [{:value, value}])

    case Parser.get_response_status(response) do
      :ok ->
        :ok

      {:error, error} ->
        IO.inspect(response, label: inspect(error))
        error
    end
  end

  def call(conn, path, params \\ []) do
    query_params = URI.encode_query([pin: pin()] ++ params)

    conn.webfsapi
    |> Kernel.<>("/" <> path)
    |> Kernel.<>("?" <> query_params)
    |> get()
    |> case do
      {:ok, %{body: body}} -> body
      {:error, :timeout} = e -> e
    end
  end

  defp pin() do
    get_config(:pin)
  end

  defp hostname() do
    "http://#{get_config(:hostname)}:#{get_config(:port)}/#{get_config(:path)}"
  end

  defp max_get_multiple_count() do
    get_config(:max_get_multiple_count)
  end

  defp get_config(key) do
    {:ok, val} = Application.fetch_env(:ex_frontier_silicon, key)
    val
  end
end
