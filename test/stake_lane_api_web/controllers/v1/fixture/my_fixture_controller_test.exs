defmodule StakeLaneApiWeb.V1.Fixture.MyFixturesControllerTest do
  use StakeLaneApiWeb.ConnCase
  import StakeLaneApi.Factory

  describe "my_fixtures/1" do
    setup %{conn: conn} do
      user = insert(:user)
      league = insert(:league)
      insert_list(3, :not_started_fixture, league: league)
      insert(:user_league, league: league, user: user)

      authed_conn = Pow.Plug.assign_current_user(conn, user, [])
      {:ok, authed_conn: authed_conn, league: league, user: user}
    end

    test "with valid params", %{authed_conn: authed_conn} do
      attrs = %{
        "page" => 0,
        "page_size" => 10,
        "tz" => "UTC"
      }
      conn = get authed_conn, Routes.api_v1_my_fixtures_path(authed_conn, :index, attrs)
      assert fixtures = json_response(conn, 200)
      assert false === Enum.empty?(fixtures)
      Enum.each(fixtures, fn fixture ->
        assert Map.has_key?(fixture, "league")
        assert Map.has_key?(fixture, "prediction")
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
      assert false === Enum.empty?(fixtures)
      Enum.each(fixtures, fn fixture ->
        assert Map.has_key?(fixture, "prediction")
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

    test "with valid params and prediction", setup_params do
      %{ authed_conn: authed_conn, league: league, user: user } = setup_params
      fixture_fabricated = insert(:not_started_fixture, league: league)
      insert(:prediction, fixture: fixture_fabricated, user: user)

      conn = get authed_conn, Routes.api_v1_my_fixtures_path(authed_conn, :index)
      assert fixtures = json_response(conn, 200)
      assert false === Enum.empty?(fixtures)

      fixture_predicted = Enum.find(fixtures, &(&1["id"] === fixture_fabricated.id))

      assert Map.has_key?(fixture_predicted["prediction"], "away_team")
      assert Map.has_key?(fixture_predicted["prediction"], "home_team")
      assert fixture_predicted["prediction"]["finished"] === false
      assert is_nil(fixture_predicted["prediction"]["score"])
    end

    test "with valid params and finished score prediction", setup_params do
      %{ authed_conn: authed_conn, league: league, user: user } = setup_params
      fixture_fabricated = insert(:past_fixture, league: league)
      insert(:prediction, %{
        fixture: fixture_fabricated,
        user: user,
        finished: true,
        score: 20,
      })

      attrs = %{ "page" => -1 }
      conn = get authed_conn, Routes.api_v1_my_fixtures_path(authed_conn, :index, attrs)
      assert fixtures = json_response(conn, 200)
      assert false === Enum.empty?(fixtures)

      fixture_predicted = Enum.find(fixtures, &(&1["id"] === fixture_fabricated.id))

      assert Map.has_key?(fixture_predicted["prediction"], "away_team")
      assert Map.has_key?(fixture_predicted["prediction"], "home_team")
      assert fixture_predicted["prediction"]["finished"] === true
      assert is_number(fixture_predicted["prediction"]["score"])
    end

    test "empty page, (past fixtures)", %{authed_conn: authed_conn} do
      attrs = %{ "page" => -1 }
      conn = get authed_conn, Routes.api_v1_my_fixtures_path(authed_conn, :index, attrs)
      assert fixtures = json_response(conn, 200)
      assert true === Enum.empty?(fixtures)
    end

  end
end
