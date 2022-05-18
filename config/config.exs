# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config
config :tesla, adapter: Tesla.Adapter.Hackney

# Configures Elixir's Logger
config :logger, :console, format: "$time $metadata[$level] $message\n"

config :ex_frontier,
  hostname: "192.168.1.151",
  max_get_multiple_count: 10,
  path: "device",
  pin: 1234,
  port: "80"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
