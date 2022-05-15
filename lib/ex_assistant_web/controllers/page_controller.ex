defmodule ExAssistantWeb.PageController do
  use ExAssistantWeb, :controller
  alias FrontierSilicon.Constants

  def index(conn, _params) do
    connection = FrontierSilicon.Connector.connect()

    params =
      Constants.get()
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {param, index} -> {index, param, get_param(connection, param)} end)

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
      |> FrontierSilicon.Connector.handle_list(param)
      |> Jason.encode!(pretty: true)
    rescue
      error ->
        IO.inspect(error)
        :error
    end
  end

  defp get_param(connection, param) do
    try do
      FrontierSilicon.Connector.handle_get(connection, param)
    rescue
      error ->
        IO.inspect(error)
        :error
    end
  end
end
