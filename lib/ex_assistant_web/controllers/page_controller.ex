defmodule ExAssistantWeb.PageController do
  use ExAssistantWeb, :controller
  alias ExFrontierSilicon.Constants

  def index(conn, _params) do
    connection = ExFrontierSilicon.Connector.connect()

    params =
      Constants.get()
      |> String.split("\n", trim: true)
      |> Enum.chunk_every(10)
      |> Enum.flat_map(&get_params(&1, connection))
      |> Enum.with_index()
      |> Enum.map(fn {{k, v}, index} -> {index, k, v} end)

    lists =
      Constants.list()
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {param, index} -> {index, param, get_list(connection, param)} end)

    render(conn, "index.html", params: params ++ lists)
  end

  defp get_list(connection, param) do
    try do
      connection
      |> ExFrontierSilicon.Connector.handle_list(param)
    rescue
      error ->
        IO.inspect(error)
        :error
    end
  end

  defp get_params(params, connection) do
    try do
      {:ok, params} =
        connection
        |> ExFrontierSilicon.Connector.handle_get_multiple(params)
        |> ExFrontierSilicon.Parser.parse_get_multiple()

      params
    rescue
      error ->
        IO.inspect(error)
        IO.inspect(__STACKTRACE__)
        :error
    end
  end
end
