import Config

config :ex_unit, timeout: :infinity

# Print only warnings and errors during test
config :logger, level: :warn

config :tesla, adapter: ExFrontier.Tesla.Mock
