defmodule BolaoHubApi.Links.UserTeam do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias BolaoHubApi.Teams.Team
  alias BolaoHubApi.Users.User

  @derive {Jason.Encoder, only: [
    :level,
    :team,
    :user,
  ]}

  schema "users_teams" do
    field :level, {:array, Ecto.Enum}, values: [:primary, :secundary, :national]
    belongs_to :team,  Team
    belongs_to :user,  User

    timestamps()
  end

  def changeset(info, attrs) do
    info
    |> cast(attrs, [:level, :team_id, :user_id])
    |> validate_required([:level, :team_id, :user_id])
    |> unique_constraint([:team_id, :user_id])
  end
end
