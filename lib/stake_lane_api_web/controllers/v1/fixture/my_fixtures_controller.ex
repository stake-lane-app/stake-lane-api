defmodule StakeLaneApiWeb.V1.Fixture.MyFixturesController do
  use StakeLaneApiWeb, :controller

  alias StakeLaneApi.Fixture

  def index(conn, params) do
    page = params |> Map.get("page", "0") |> String.to_integer
    page_size = params |> Map.get("page_size", "10") |> String.to_integer
    tz = params |> Map.get("tz", "UTC")

    conn
    |> Pow.Plug.current_user
    |> Map.get(:id)
    |> (&(Fixture.get_my_fixtures(&1, tz, page , page_size))).()
    |> case do
      leagues ->
        conn
        |> put_status(200)
        |> json(leagues)
    end
  end

end
