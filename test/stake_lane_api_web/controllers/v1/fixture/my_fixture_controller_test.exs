defmodule StakeLaneApiWeb.V1.League.MyFixturesControllerTest do
  use StakeLaneApiWeb.ConnCase
  import StakeLaneApi.Factory

  describe "my_fixtures/1" do
    setup %{conn: conn} do
      user = insert(:user)
      country = insert(:country)
      league = insert(:league, country: country)
      insert_list(3, :fixture, league: league)
      insert(:user_league, league: league, user: user)

      authed_conn = Pow.Plug.assign_current_user(conn, user, [])
      {:ok, authed_conn: authed_conn, league: league}
    end

    test "with valid params", %{authed_conn: authed_conn} do
      attrs = %{
        "page" => 0,
        "page_size" => 10,
        "tz" => "UTC"
      }
      conn = get authed_conn, Routes.api_v1_my_fixtures_path(authed_conn, :index, attrs)
      assert fixtures = json_response(conn, 200)
      assert false == Enum.empty?(fixtures)
      Enum.map(fixtures, fn fixture ->
        assert Map.has_key?(fixture, "league")
        assert Map.has_key?(fixture, "home_team")
        assert Map.has_key?(fixture, "away_team")
        assert Map.has_key?(fixture, "goals_home_team")
        assert Map.has_key?(fixture, "goals_away_team")
        assert Map.has_key?(fixture, "starts_at_iso_date")
        assert Map.has_key?(fixture, "status_code")
        assert Map.has_key?(fixture, "elapsed")
      end)
    end

    test "with valid params, past fixtures", setup_params do
      %{ authed_conn: authed_conn, league: league } = setup_params

      insert_list(2, :past_fixture, league: league)
      attrs = %{ "page" => -1 }
      conn = get authed_conn, Routes.api_v1_my_fixtures_path(authed_conn, :index, attrs)
      assert fixtures = json_response(conn, 200)
      assert false == Enum.empty?(fixtures)
      Enum.map(fixtures, fn fixture ->
        assert Map.has_key?(fixture, "league")
        assert Map.has_key?(fixture, "home_team")
        assert Map.has_key?(fixture, "away_team")
        assert Map.has_key?(fixture, "goals_home_team")
        assert Map.has_key?(fixture, "goals_away_team")
        assert Map.has_key?(fixture, "starts_at_iso_date")
        assert Map.has_key?(fixture, "status_code")
        assert Map.has_key?(fixture, "elapsed")
      end)
    end

    test "empty page, (past fixtures)", %{authed_conn: authed_conn} do
      attrs = %{ "page" => -1 }
      conn = get authed_conn, Routes.api_v1_my_fixtures_path(authed_conn, :index, attrs)
      assert fixtures = json_response(conn, 200)
      assert true == Enum.empty?(fixtures)
    end

  end
end
