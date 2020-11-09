defmodule BolaoHubApiWeb.V1.League.LeagueController do
  use BolaoHubApiWeb, :controller

  alias BolaoHubApi.League

  def index(conn, _) do
    League.list_leagues
    |> case do
      leagues ->
        conn
        |> put_status(200)
        |> json(leagues)
    end
  end

end
