# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :stake_lane_api,
  ecto_repos: [StakeLaneApi.Repo]

# Configures the endpoint
config :stake_lane_api, StakeLaneApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "uHcfIbzvYY75qry1dPST+t3r2RgPkZmZQlsdRPsqbkgFkCE75EbiHJIhSgkn60ht",
  render_errors: [view: StakeLaneApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: StakeLaneApi.PubSub,
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
config :stake_lane_api, :pow,
  user: StakeLaneApi.Users.User,
  repo: StakeLaneApi.Repo

config :stake_lane_api, :pow_assent,
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
config :stake_lane_api,
  StakeLaneApiWeb.Gettext,
  default_locale: "en"

# Postgis
config :stake_lane_api, StakeLaneApi.Repo,
types: StakeLaneApi.PostgresTypes

config :geo_postgis,
  json_library: Jason

# API Football
config :stake_lane_api, :football_api,
  url: System.get_env("API_FOOTBALL_URL") || "https://v2.api-football.com",
  key: System.get_env("API_FOOTBALL_KEY") || "686819f61ee767103c876669418c2156"
