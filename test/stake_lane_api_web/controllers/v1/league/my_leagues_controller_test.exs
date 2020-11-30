defmodule StakeLaneApiWeb.API.V1.League.MyLeaguesControllerTest do
  use StakeLaneApiWeb.ConnCase
  import StakeLaneApi.Factory

  describe "list/2" do
    setup %{conn: conn} do
      user = insert(:user)

      supported_user_team = insert(:team, %{name: "Porto F.C."})
      national_championship = insert(:league, %{name: "Bundesliga"})
      continental_cup = insert(:league, %{name: "Libertadores Cup"})

      insert(:user_team_league, %{ team: supported_user_team, user: user })
      insert(:user_league, league: national_championship, user: user)
      insert(:user_league, league: continental_cup, user: user)

      authed_conn = Pow.Plug.assign_current_user(conn, user, [])
      {:ok, authed_conn: authed_conn}
    end

    test "with valid params", %{authed_conn: authed_conn} do
      conn = get authed_conn, Routes.api_v1_my_leagues_path(authed_conn, :index)
      assert leagues = json_response(conn, 200)
      assert false === Enum.empty?(leagues)

      assert Enum.all?(leagues, fn league ->
        league["type"] === "team" or
        league["type"] === "league"
      end)

      Enum.map(leagues, fn league ->
        case league["type"] do
          "team" ->
            assert Map.has_key?(league, "country")
            assert Map.has_key?(league, "founded")
            assert Map.has_key?(league, "is_national")
            assert Map.has_key?(league, "logo")
            assert Map.has_key?(league, "name")
            assert Map.has_key?(league, "team_id")

          "league" ->
            assert Map.has_key?(league, "active")
            assert Map.has_key?(league, "country")
            assert Map.has_key?(league, "league_id")
            assert Map.has_key?(league, "name")
            assert Map.has_key?(league, "season")
        end
      end)
    end

  end
end
