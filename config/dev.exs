use Mix.Config

# Configure your database
config :stake_lane_api, StakeLaneApi.Repo,
  username: "postgres",
  password: "postgres",
  database: "stake_lane_api_dev",
  # Locally in the machine
  hostname: "localhost",
  # From container
  # hostname: "database",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :stake_lane_api, StakeLaneApiWeb.Endpoint,
  http: [port: 8080],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [],
  server: true

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Oban
every_even_minute = "*/2 * * * *"

config :stake_lane_api, Oban,
  repo: StakeLaneApi.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10, events: 50, media: 20],
  crontab: [
    # https://github.com/sorentwo/oban#periodic-jobs
    {"@weekly", StakeLaneApi.Workers.UpsertCountries, max_attempts: 2},
    {"@weekly", StakeLaneApi.Workers.UpdateLeagues, max_attempts: 2},
    {"@weekly", StakeLaneApi.Workers.UpsertTeams, max_attempts: 3},
    {"@daily", StakeLaneApi.Workers.UpsertFixtures, max_attempts: 3},
    {every_even_minute, StakeLaneApi.Workers.UpdateFixtures, max_attempts: 1}
  ]
