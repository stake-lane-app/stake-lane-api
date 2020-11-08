defmodule BolaoHubApi.UserTeam do
  @moduledoc """
  The UserLeague context.
  """

  import Ecto.Query, warn: false
  alias BolaoHubApi.Repo
  alias BolaoHubApi.Links.UserTeam

  def get_user_teams(user_id) do
    query = from ut in UserTeam,
      inner_join: team in assoc(ut,  :team),
      where: ut.user_id == ^user_id,
      preload: [
        team: team,
      ]

    Repo.all query
  end
end
