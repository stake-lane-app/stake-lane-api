defmodule BolaoHubApi.UserTeam do
  @moduledoc """
  The UserLeague context.
  """

  import Ecto.Query, warn: false
  alias BolaoHubApi.Repo
  alias BolaoHubApi.Links.UserTeam

  def get_user_teams(user_id) do
    query = from user_team in UserTeam,
      inner_join: team in assoc(user_team,  :team),
      inner_join: country in assoc(team, :team),
      where: user_team.user_id == ^user_id,
      select: %{
        level_type: user_team.level_type,
        team_id: team.team_id,
        name: team.name,
        full_name: team.full_name,
        logo: team.logo,
        is_national: team.is_national,
        founded: team.founded,
        venue: team.venue,
        country: country,
      }

    Repo.all query
  end
end
