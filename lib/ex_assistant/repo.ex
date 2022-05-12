defmodule ExAssistant.Repo do
  use Ecto.Repo,
    otp_app: :ex_assistant,
    adapter: Ecto.Adapters.Postgres
end
