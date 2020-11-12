defmodule StakeLaneApiWeb.API.V1.League.LeaguesControllerTest do
  use StakeLaneApiWeb.ConnCase

  describe "list/2" do
    setup %{conn: conn} do
      # Populate Database
      "create_mvp_countries_leagues.exs"
      |> StakeLaneApi.Seeds.run

      # Create User
      user = %StakeLaneApi.Users.User{user_name: "test_user", id: 1}
      authed_conn = Pow.Plug.assign_current_user(conn, user, [])
      {:ok, authed_conn: authed_conn}
    end

    test "with valid params", %{authed_conn: authed_conn} do
      conn = get authed_conn, Routes.api_v1_leagues_path(authed_conn, :index)
      assert json = json_response(conn, 200)

      Enum.map(json, fn league ->
        assert league["active"]
        assert league["country"]
        assert league["league_id"]
        assert league["name"]
        assert league["season"]
      end)
    end

  end
end
