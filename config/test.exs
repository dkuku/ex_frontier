import Config

# Print only warnings and errors during test
config :logger, level: :warn

config :ex_unit, timeout: :infinity

config :tesla, adapter: ExFrontier.Tesla.Mock
