defmodule StakeLaneApiWeb.V1.League.MyLeagueFixtureController do
  use StakeLaneApiWeb, :controller

  alias StakeLaneApi.League
  alias StakeLaneApi.UserLeague

  def index(conn, _) do
    user_id = conn
    |> Pow.Plug.current_user
    |> Map.get(:id)

    response = user_id
    |> UserLeague.get_user_leagues_id
    |> League.list_leagues_with_fixture

    json(conn, response)
  end
end
