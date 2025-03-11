defmodule ExFrontier.Conn do
  @moduledoc false
  @behaviour Access

  defstruct [:friendly_name, :session_id, :version, :webfsapi]

  defdelegate get(v, key, default), to: Map
  defdelegate fetch(v, key), to: Map
  defdelegate get_and_update(v, key, func), to: Map
  defdelegate pop(v, key), to: Map
end
