use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :stake_lane_api, StakeLaneApi.Repo,
  username: "postgres",
  password: "postgres",
  port: 5433,
  database: "stake_lane_api_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :stake_lane_api, StakeLaneApiWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
# Print everything during test
# config :logger, level: :debug

config :stake_lane_api, Oban,
  repo: StakeLaneApi.Repo,
  plugins: [Oban.Plugins.Pruner],
  crontab: []
