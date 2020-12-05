defmodule StakeLaneApi.Links.UserTeam do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias StakeLaneApi.Football.Team
  alias StakeLaneApi.Users.User

  @derive {Jason.Encoder,
           only: [
             :level,
             :team,
             :user
           ]}

  schema "users_teams" do
    field :level, Ecto.Enum, values: [:primary, :second, :third, :national]
    belongs_to :team, Team
    belongs_to :user, User

    timestamps()
  end

  def changeset(info, attrs) do
    info
    |> cast(attrs, [:level, :team_id, :user_id])
    |> validate_required([:level, :team_id, :user_id])
    |> unique_constraint([:team_id, :user_id])
    |> unique_constraint([:level, :user_id])
  end
end

defmodule StakeLaneApi.Links.UserTeam.Level do
  def team_levels do
    %{
      primary: "primary",
      second: "second",
      third: "third",
      national: "national"
    }
  end
end
