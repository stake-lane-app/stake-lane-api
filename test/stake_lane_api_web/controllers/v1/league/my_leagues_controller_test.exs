defmodule StakeLaneApiWeb.API.V1.League.MyLeaguesControllerTest do
  use StakeLaneApiWeb.ConnCase
  import StakeLaneApi.Factory
  alias StakeLaneApi.Finances.Plan

  describe "list/2" do
    setup %{conn: conn} do
      user = insert(:user)

      loved_user_team = insert(:team, %{name: "Porto F.C."})
      supported_user_team = insert(:team, %{name: "Sport Recife"})
      national_championship = insert(:league, %{name: "Bundesliga"})
      continental_cup = insert(:league, %{name: "Libertadores Cup"})

      insert(:user_team_league, %{team: supported_user_team, user: user})
      insert(:user_team_league, %{team: loved_user_team, user: user})
      insert(:user_league, league: national_championship, user: user)
      insert(:user_league, league: continental_cup, user: user)

      authed_conn = Pow.Plug.assign_current_user(conn, user, [])
      {:ok, authed_conn: authed_conn, conn: conn}
    end

    test "with valid params", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.api_v1_my_leagues_path(authed_conn, :index))
      assert leagues = json_response(conn, 200)
      assert false === Enum.empty?(leagues)
      assert 4 === length(leagues)

      assert Enum.all?(leagues, fn league ->
               league["type"] in ["team", "league"]
             end)

      Enum.map(leagues, fn league ->
        assert Map.has_key?(league, "total_score")
        assert Map.has_key?(league, "blocked")
        assert Map.has_key?(league, "name")
        assert Map.has_key?(league, "country")

        case league["type"] do
          "team" ->
            assert Map.has_key?(league, "team_id")
            assert Map.has_key?(league, "founded")
            assert Map.has_key?(league, "is_national")
            assert Map.has_key?(league, "logo")

          "league" ->
            assert Map.has_key?(league, "league_id")
            assert Map.has_key?(league, "active")
            assert Map.has_key?(league, "season")
        end
      end)
    end
  end

  describe "create/2" do
    setup %{conn: conn} do
      insert(:plan)
      authed_conn = Pow.Plug.assign_current_user(conn, insert(:user), [])
      {:ok, authed_conn: authed_conn}
    end

    test "with valid params, championship league", %{authed_conn: authed_conn} do
      league = insert(:league)
      body = %{league_id: league.id}

      conn = post authed_conn, Routes.api_v1_my_leagues_path(authed_conn, :index), body
      assert conn.status == 204
    end

    test "with valid params, team league", %{conn: conn} do
      other_user = insert(:user)
      other_authed_conn = Pow.Plug.assign_current_user(conn, other_user, [])

      number_one_fan_plan = insert(:plan, name: :number_one_fan)
      insert(:user_plan, plan: number_one_fan_plan, user: other_user)

      team = insert(:team)
      body = %{team_id: team.id}

      conn = post other_authed_conn, Routes.api_v1_my_leagues_path(other_authed_conn, :index), body
      assert conn.status == 204
    end

    test "trying to play a team-league with a free plan", %{authed_conn: authed_conn} do
      team = insert(:team)
      body = %{ team_id: team.id }

      conn = post authed_conn, Routes.api_v1_my_leagues_path(authed_conn, :index), body
      assert error = json_response(conn, 400)
      assert error["treated_error"]["message"] == "Your slots are full, you can't play this team-league"
    end

    test "creating more than allowed on free plan", %{authed_conn: authed_conn} do
      limit_allowed = Plan.Types.plans()[:free].leagues

      for _ <- 1..limit_allowed |> Enum.to_list() do
        team = insert(:league)
        body = %{league_id: team.id}
        conn = post authed_conn, Routes.api_v1_my_leagues_path(authed_conn, :index), body
        assert conn.status == 204
      end

      body = %{league_id: insert(:league).id}
      conn = post authed_conn, Routes.api_v1_my_leagues_path(authed_conn, :index), body
      assert error = json_response(conn, 400)

      assert error["treated_error"]["message"] ==
               "Your slots are full, you can't add more leagues"
    end

    test "invalid request", %{authed_conn: authed_conn} do
      conn = post authed_conn, Routes.api_v1_my_leagues_path(authed_conn, :index), %{}
      assert error = json_response(conn, 400)
      assert error["error"]["message"] == "Couldn't link the league"
    end
  end
end
