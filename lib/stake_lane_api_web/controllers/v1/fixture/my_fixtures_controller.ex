defmodule StakeLaneApiWeb.V1.League.MyFixturesController do
  use StakeLaneApiWeb, :controller

  # alias Ecto.Changeset
  alias StakeLaneApi.Fixture
  # alias StakeLaneApiWeb.ErrorHelpers

  def index(conn, _) do
    conn
    |> Pow.Plug.current_user
    |> Map.get(:id)
    |> (&(Fixture.get_my_fixtures/1)).()
    |> case do
      leagues ->
        conn
        |> put_status(200)
        |> json(leagues)
    end
  end

end
