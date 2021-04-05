defmodule StakeLaneApiWeb.V1.Fixture.MyFixturesControllerTest do
  use StakeLaneApiWeb.ConnCase
  import StakeLaneApi.Factory

  def fixture_asserted?(fixture) do
    assert Map.has_key?(fixture, "league")
    assert Map.has_key?(fixture, "prediction")
    assert Map.has_key?(fixture, "home_team")
    assert Map.has_key?(fixture, "away_team")
    assert Map.has_key?(fixture, "goals_home_team")
    assert Map.has_key?(fixture, "goals_away_team")
    assert Map.has_key?(fixture, "starts_at_iso_date")
    assert Map.has_key?(fixture, "status_code")
    assert Map.has_key?(fixture, "elapsed")
  end

  describe "my_fixtures/1" do
    setup %{conn: conn} do
      user = insert(:user)
      league = insert(:league)
      insert_list(3, :not_started_fixture, league: league)
      insert(:user_league, league: league, user: user)

      authed_conn = Pow.Plug.assign_current_user(conn, user, [])
      {:ok, authed_conn: authed_conn, league: league, user: user, conn: conn}
    end

    test "with valid params, solely league mode", %{authed_conn: authed_conn, league: league} do
      attrs = %{
        "page" => 0,
        "page_size" => 10,
        "tz" => "UTC"
      }

      conn = get(authed_conn, Routes.api_v1_my_fixtures_path(authed_conn, :index, attrs))
      assert fixtures = json_response(conn, 200)
      assert false === Enum.empty?(fixtures)

      Enum.each(fixtures, &fixture_asserted?(&1))

      assert Enum.all?(fixtures, fn fixture -> fixture["league"]["name"] === league.name end)
    end

    test "with valid params, solely team-league mode", %{conn: conn} do
      user = insert(:user)
      authed_conn = Pow.Plug.assign_current_user(conn, user, [])

      supported_user_team = insert(:team, %{name: "1# Fan F.C."})
      national_championship = insert(:league, %{name: "National Championship"})
      national_cup = insert(:league, %{name: "National Cup"})
      continental_cup = insert(:league, %{name: "Continental Cup"})

      insert(:not_started_fixture, %{
        league: national_championship,
        home_team: supported_user_team
      })

      insert(:not_started_fixture, %{league: national_cup, away_team: supported_user_team})
      insert(:not_started_fixture, %{league: continental_cup, home_team: supported_user_team})
      insert(:user_team_league, %{team: supported_user_team, user: user})

      conn = get(authed_conn, Routes.api_v1_my_fixtures_path(authed_conn, :index))
      assert fixtures = json_response(conn, 200)
      assert false === Enum.empty?(fixtures)

      assert Enum.all?(fixtures, fn fixture ->
               fixture["league"]["name"] === national_championship.name or
                 fixture["league"]["name"] === national_cup.name or
                 fixture["league"]["name"] === continental_cup.name
             end)

      assert Enum.all?(fixtures, fn fixture ->
               fixture["home_team"]["name"] === supported_user_team.name or
                 fixture["away_team"]["name"] === supported_user_team.name
             end)
    end

    test "with valid params, mixing league and team-league", setup_params do
      %{authed_conn: authed_conn, league: league, user: user} = setup_params

      supported_user_team = insert(:team, %{name: "1# Fan F.C."})
      insert(:not_started_fixture, %{home_team: supported_user_team})
      insert(:not_started_fixture, %{away_team: supported_user_team})
      insert(:user_team_league, %{team: supported_user_team, user: user})

      conn = get(authed_conn, Routes.api_v1_my_fixtures_path(authed_conn, :index))
      assert fixtures = json_response(conn, 200)
      assert false === Enum.empty?(fixtures)

      assert Enum.find(fixtures, fn fixture ->
               fixture["home_team"]["name"] === supported_user_team.name
             end)

      assert Enum.find(fixtures, fn fixture ->
               fixture["away_team"]["name"] === supported_user_team.name
             end)

      assert Enum.find(fixtures, fn fixture -> fixture["league"]["name"] === league.name end)
    end

    test "with valid params, past fixtures, page -1", setup_params do
      %{authed_conn: authed_conn, league: league} = setup_params

      insert_list(2, :past_fixture, league: league)
      attrs = %{"page" => -1}
      conn = get(authed_conn, Routes.api_v1_my_fixtures_path(authed_conn, :index, attrs))
      assert fixtures = json_response(conn, 200)
      assert false === Enum.empty?(fixtures)

      Enum.each(fixtures, &fixture_asserted?(&1))
    end

    test "with valid params, past fixtures, page -2", setup_params do
      %{authed_conn: authed_conn, league: league} = setup_params

      insert_list(2, :past_fixture, league: league)
      attrs = %{"page" => -2, "page_size" => 1}
      conn = get(authed_conn, Routes.api_v1_my_fixtures_path(authed_conn, :index, attrs))
      assert fixtures = json_response(conn, 200)
      assert false === Enum.empty?(fixtures)

      Enum.each(fixtures, &fixture_asserted?(&1))
    end

    test "with valid params and prediction", setup_params do
      %{authed_conn: authed_conn, league: league, user: user} = setup_params
      fixture_fabricated = insert(:not_started_fixture, league: league)
      insert(:prediction, fixture: fixture_fabricated, user: user)

      conn = get(authed_conn, Routes.api_v1_my_fixtures_path(authed_conn, :index))
      assert fixtures = json_response(conn, 200)
      assert false === Enum.empty?(fixtures)

      fixture_predicted = Enum.find(fixtures, &(&1["id"] === fixture_fabricated.id))

      assert Map.has_key?(fixture_predicted["prediction"], "away_team")
      assert Map.has_key?(fixture_predicted["prediction"], "home_team")
      assert fixture_predicted["prediction"]["finished"] === false
      assert is_nil(fixture_predicted["prediction"]["score"])
    end

    test "with valid params and finished score prediction", setup_params do
      %{authed_conn: authed_conn, league: league, user: user} = setup_params
      fixture_fabricated = insert(:past_fixture, league: league)

      insert(:prediction, %{
        fixture: fixture_fabricated,
        user: user,
        finished: true,
        score: 20
      })

      attrs = %{"page" => -1}
      conn = get(authed_conn, Routes.api_v1_my_fixtures_path(authed_conn, :index, attrs))
      assert fixtures = json_response(conn, 200)
      assert false === Enum.empty?(fixtures)

      fixture_predicted = Enum.find(fixtures, &(&1["id"] === fixture_fabricated.id))

      assert Map.has_key?(fixture_predicted["prediction"], "away_team")
      assert Map.has_key?(fixture_predicted["prediction"], "home_team")
      assert fixture_predicted["prediction"]["finished"] === true
      assert is_number(fixture_predicted["prediction"]["score"])
    end

    test "empty page, (past fixtures)", %{authed_conn: authed_conn} do
      attrs = %{"page" => -1}
      conn = get(authed_conn, Routes.api_v1_my_fixtures_path(authed_conn, :index, attrs))
      assert fixtures = json_response(conn, 200)
      assert true === Enum.empty?(fixtures)
    end
  end
end
