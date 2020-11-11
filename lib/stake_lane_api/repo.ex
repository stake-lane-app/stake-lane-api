defmodule StakeLaneApi.Repo do
  use Ecto.Repo,
    otp_app: :stake_lane_api,
    adapter: Ecto.Adapters.Postgres
end
