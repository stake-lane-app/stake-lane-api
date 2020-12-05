defmodule StakeLaneApiWeb.V1.League.LeaguesController do
  use StakeLaneApiWeb, :controller

  alias StakeLaneApi.League

  def index(conn, _) do
    League.list_leagues()
    |> case do
      leagues ->
        conn
        |> put_status(200)
        |> json(leagues)
    end
  end
end
