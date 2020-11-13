defmodule StakeLaneApiWeb.V1.League.MyFixturesController do
  use StakeLaneApiWeb, :controller

  # alias Ecto.Changeset
  alias StakeLaneApi.Fixture
  # alias StakeLaneApiWeb.ErrorHelpers

  def index(conn, params) do
    %{ "page" => page, "page_size" => page_size, "tz" => tz } = params

    page = page |> String.to_integer
    page_size = page_size |> String.to_integer

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
