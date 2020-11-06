# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bolao_hub_api,
  ecto_repos: [BolaoHubApi.Repo]

# Configures the endpoint
config :bolao_hub_api, BolaoHubApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "uHcfIbzvYY75qry1dPST+t3r2RgPkZmZQlsdRPsqbkgFkCE75EbiHJIhSgkn60ht",
  render_errors: [view: BolaoHubApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: BolaoHubApi.PubSub,
  live_view: [signing_salt: "laziPMgk"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# Pow
config :bolao_hub_api, :pow,
  user: BolaoHubApi.Users.User,
  repo: BolaoHubApi.Repo

config :bolao_hub_api, :pow_assent,
  providers: [
    facebook: [
      client_id: System.get_env("FACEBOOK_CLIENT_ID"),
      client_secret: System.get_env("FACEBOOK_CLIENT_SECRET"),
      strategy: Assent.Strategy.Facebook,
      nonce: true,
    ],
    google: [
      client_id: System.get_env("GOOGLE_CLIENT_ID"),
      client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
      strategy: Assent.Strategy.Google,
    ]
  ]

# Get Text
config :bolao_hub_api,
  BolaoHubApiWeb.Gettext,
  default_locale: "en"

# Postgis
config :bolao_hub_api, BolaoHubApi.Repo,
types: BolaoHubApi.PostgresTypes

config :geo_postgis,
  json_library: Jason

# Oban
every_minute = "* * * * *"
config :bolao_hub_api, Oban,
  repo: BolaoHubApi.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10, events: 50, media: 20],
  crontab: [
    # https://github.com/sorentwo/oban#periodic-jobs
    {"@weekly", BolaoHubApi.Workers.UpdateLeagues},
    {"@weekly", BolaoHubApi.Workers.UpsertTeams},
    {"@weekly", BolaoHubApi.Workers.UpsertCountries},
    {"@weekly", BolaoHubApi.Workers.UpsertFixtures},   # Get Fixtures by League
    {every_minute, BolaoHubApi.Workers.UpdateResults}, # Get Fixtures by Date
  ]

config :bolao_hub_api, :football_api,
  url: System.get_env("API_FOOTBALL_URL") || "https://v2.api-football.com",
  key: System.get_env("API_FOOTBALL_KEY") || "686819f61ee767103c876669418c2156"
