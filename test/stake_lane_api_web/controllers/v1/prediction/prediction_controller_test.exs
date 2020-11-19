defmodule StakeLaneApiWeb.API.V1.Prediction.PredictionsControllerTest do
  use StakeLaneApiWeb.ConnCase
  import StakeLaneApi.Factory
  alias StakeLaneApi.Football.Fixture.Status

  describe "create/2" do
    setup %{conn: conn} do
      user = insert(:user)
      league = insert(:league)
      fixture = insert(:fixture, league: league)

      insert(:user_league, league: league, user: user)

      authed_conn = Pow.Plug.assign_current_user(conn, user, [])
      {:ok, authed_conn: authed_conn, fixture: fixture, user: user, league: league}
    end

    test "with valid params", %{authed_conn: authed_conn, fixture: fixture} do
      body = %{
        fixture_id: fixture.id,
        prediction_home_team: 1,
        prediction_away_team: 0,
      }

      conn = post authed_conn, Routes.api_v1_predictions_path(authed_conn, :create), body
      assert conn.status == 204
    end

    test "with running fixture", %{authed_conn: authed_conn, league: league} do
      live_fixture = insert(:fixture, %{
        league: league,
        status_code: Status.fixtures_status()[:second_half][:code]
      })

      body = %{
        fixture_id: live_fixture.id,
        prediction_home_team: 1,
        prediction_away_team: 0,
      }

      conn = post authed_conn, Routes.api_v1_predictions_path(authed_conn, :create), body
      assert error = json_response(conn, 400)
      assert error["treated_error"]["message"] == "The fixture status does not allow prediction"
    end

    test "with non-existing fixture", %{authed_conn: authed_conn} do
      body = %{
        fixture_id: 99999,
        prediction_home_team: 1,
        prediction_away_team: 0,
      }

      conn = post authed_conn, Routes.api_v1_predictions_path(authed_conn, :create), body
      assert error = json_response(conn, 404)
      assert error["treated_error"]["message"] == "Fixture not found"
    end

    test "with a league the users doesnt play", %{authed_conn: authed_conn} do
      new_fixture = insert(:fixture)
      body = %{
        fixture_id: new_fixture.id,
        prediction_home_team: 1,
        prediction_away_team: 0,
      }

      conn = post authed_conn, Routes.api_v1_predictions_path(authed_conn, :create), body
      assert error = json_response(conn, 400)
      assert error["treated_error"]["message"] == "You don't play this league"
    end

    test "with valid params, overwriting previous prediction", %{authed_conn: authed_conn, fixture: fixture} do
      body = %{
        fixture_id: fixture.id,
        prediction_home_team: 1,
        prediction_away_team: 0,
      }

      post authed_conn, Routes.api_v1_predictions_path(authed_conn, :create), body

      another_body = %{
        fixture_id: fixture.id,
        prediction_home_team: 1,
        prediction_away_team: 3,
      }
      conn = post authed_conn, Routes.api_v1_predictions_path(authed_conn, :create), another_body
      assert conn.status == 204
    end

  end
end
