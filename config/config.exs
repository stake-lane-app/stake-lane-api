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

# Get Text
config :bolao_hub_api,
  BolaoHubApiWeb.Gettext,
  default_locale: "en"

# Geo Lix
config :geolix,
databases: [
  %{
    id: :city,
    adapter: Geolix.Adapter.MMDB2,
    source: Path.absname("priv/geolite2/city20200922.mmdb")
  }
]


# Postgis
config :bolao_hub_api, BolaoHubApi.Repo,
types: BolaoHubApi.PostgresTypes

config :geo_postgis,
  json_library: Jason