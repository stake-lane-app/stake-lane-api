defmodule StakeLaneApi.Links.UserTeamLeague do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias StakeLaneApi.Football.Team
  alias StakeLaneApi.Users.User

  @derive {Jason.Encoder,
           only: [
             :team,
             :user,
             :blocked
           ]}

  schema "users_teams_leagues" do
    field :blocked, :boolean
    belongs_to :team, Team
    belongs_to :user, User

    timestamps()
  end

  def changeset(info, attrs) do
    info
    |> cast(attrs, [:blocked, :team_id, :user_id])
    |> validate_required([:team_id, :user_id])
    |> unique_constraint([:team_id, :user_id])
  end
end
