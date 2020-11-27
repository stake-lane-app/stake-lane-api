defmodule StakeLaneApiWeb.API.V1.Team.TeamsControllerTest do
  use StakeLaneApiWeb.ConnCase
  import StakeLaneApi.Factory
  alias StakeLaneApi.Links.UserTeam.Level

  describe "list/2" do
    @quantity 3
    setup %{conn: conn} do
      country = insert(:country)
      insert_list(@quantity, :team, country: country)
      insert_list(2, :team, country: insert(:country))


      authed_conn = Pow.Plug.assign_current_user(conn, insert(:user), [])
      {:ok, authed_conn: authed_conn, country: country}
    end

    test "with valid params", %{authed_conn: authed_conn, country: country} do
      attrs = %{
        "country_id" => country.id,
      }
      conn = get authed_conn, Routes.api_v1_teams_path(authed_conn, :index, attrs)
      assert teams = json_response(conn, 200)
      assert false === Enum.empty?(teams)
      assert @quantity === length(teams)
      Enum.map(teams, fn team ->
        assert Map.has_key?(team, "id")
        assert Map.has_key?(team, "is_national")
        assert Map.has_key?(team, "full_name")
        assert Map.has_key?(team, "name")
        assert Map.has_key?(team, "founded")
        assert Map.has_key?(team, "venue")
        assert Map.has_key?(team, "country")
      end)
    end

  end

  describe "edit/2" do
    setup %{conn: conn} do

      authed_conn = Pow.Plug.assign_current_user(conn, insert(:user), [])
      {:ok, authed_conn: authed_conn}
    end

    test "with valid params", %{authed_conn: authed_conn} do
      team = insert(:team)

      body = %{
        team_id: team.id,
        level: Level.team_levels[:primary],
      }
      conn = post authed_conn, Routes.api_v1_teams_path(authed_conn, :create), body
      assert conn.status == 204
    end

    test "with valid params, national team", %{authed_conn: authed_conn} do
      national_team = insert(:team, %{is_national: true})

      body = %{
        team_id: national_team.id,
        level: Level.team_levels[:national],
      }
      conn = post authed_conn, Routes.api_v1_teams_path(authed_conn, :create), body
      assert conn.status == 204
    end

    test "with valid params, overwriting", %{authed_conn: authed_conn} do
      team_a = insert(:team)
      team_b = insert(:team)

      body_a = %{
        team_id: team_a.id,
        level: Level.team_levels[:second],
      }
      conn = post authed_conn, Routes.api_v1_teams_path(authed_conn, :create), body_a
      assert conn.status == 204

      body_b = %{
        team_id: team_b.id,
        level: Level.team_levels[:second],
      }
      conn = post authed_conn, Routes.api_v1_teams_path(authed_conn, :create), body_b
      assert conn.status == 204
    end

    test "trying to use a national team as a club", %{authed_conn: authed_conn} do
      national_team = insert(:team, %{is_national: true})

      body = %{
        team_id: national_team.id,
        level: Level.team_levels[:primary],
      }
      conn = post authed_conn, Routes.api_v1_teams_path(authed_conn, :create), body
      assert error = json_response(conn, 400)
      assert error["treated_error"]["message"] == "The team needs to be national"
    end

    test "trying to add same team on diff level", %{authed_conn: authed_conn} do
      team = insert(:team)

      body_a = %{
        team_id: team.id,
        level: Level.team_levels[:primary],
      }
      conn = post authed_conn, Routes.api_v1_teams_path(authed_conn, :create), body_a
      assert conn.status == 204

      body_b = %{
        team_id: team.id,
        level: Level.team_levels[:second],
      }
      conn = post authed_conn, Routes.api_v1_teams_path(authed_conn, :create), body_b
      assert error = json_response(conn, 400)
      assert error["treated_error"]["message"] == "You already support this team"
    end

  end

  describe "delete/2" do
    setup %{conn: conn} do
      user = insert(:user)

      authed_conn = Pow.Plug.assign_current_user(conn, user, [])
      {:ok, authed_conn: authed_conn, user: user}
    end

    test "with valid params", %{authed_conn: authed_conn, user: user} do
      user_team = insert(:user_team, %{ user: user })
      body = %{ "level" => user_team.level }

      conn = delete authed_conn, Routes.api_v1_teams_path(authed_conn, :index), body
      assert conn.status == 204
    end

    test "trying to delete non-existing user team", %{authed_conn: authed_conn} do
      body = %{
        "level" => Level.team_levels[:third],
      }
      conn = delete authed_conn, Routes.api_v1_teams_path(authed_conn, :index), body
      assert error = json_response(conn, 400)
      assert error["treated_error"]["message"] == "We've not found any team preference at this level"
    end

  end
end
