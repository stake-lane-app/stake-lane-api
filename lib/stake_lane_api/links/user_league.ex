defmodule StakeLaneApi.Links.UserLeague do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias StakeLaneApi.Football.League
  alias StakeLaneApi.Users.User

  @derive {Jason.Encoder, only: [
    :league,
    :user,
    :blocked,
  ]}

  schema "users_leagues" do
    field :blocked, :boolean
    belongs_to :league,  League
    belongs_to :user,  User

    timestamps()
  end

  def changeset(info, attrs) do
    info
    |> cast(attrs, [:blocked, :league_id, :user_id])
    |> validate_required([:league_id, :user_id])
    |> unique_constraint([:league_id, :user_id])
  end
end
