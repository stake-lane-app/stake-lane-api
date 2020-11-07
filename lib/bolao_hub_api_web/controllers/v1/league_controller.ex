defmodule BolaoHubApiWeb.V1.LeagueController do
  use BolaoHubApiWeb, :controller

  alias BolaoHubApi.League

  def index(conn, _) do

    # Remove hardcoded
    premier_league = 5
    la_liga = 8
    bundesliga = 10
    serie_a = 14

    json(conn, League.fixtures_by_league_ids([premier_league, la_liga, bundesliga, serie_a]))
  end

end
