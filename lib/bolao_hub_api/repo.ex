defmodule BolaoHubApi.Repo do
  use Ecto.Repo,
    otp_app: :bolao_hub_api,
    adapter: Ecto.Adapters.Postgres
end
