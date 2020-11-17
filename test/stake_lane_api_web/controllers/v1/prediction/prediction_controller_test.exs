defmodule StakeLaneApiWeb.API.V1.Prediction.PredictionsControllerTest do
  use StakeLaneApiWeb.ConnCase
  import StakeLaneApi.Factory

  describe "create/2" do
    setup %{conn: conn} do
      user = insert(:user)
      country = insert(:country)
      league = insert(:league, country: country)
      fixture = insert(:fixture, league: league)

      insert(:user_league, league: league, user: user)

      authed_conn = Pow.Plug.assign_current_user(conn, user, [])
      {:ok, authed_conn: authed_conn, fixture: fixture, user: user}
    end

    test "with valid params", %{authed_conn: authed_conn, fixture: fixture, user: user} do
      body = %{
        user_id: user.id,
        fixture_id: fixture.id,
        prediction_home_team: 1,
        prediction_away_team: 0,
      }

      conn = post authed_conn, Routes.api_v1_predictions_path(authed_conn, :create), body
      assert conn.status == 204
    end

    # TO DO: Validate if user has the user_league relation created and not-blocked
    # TO DO: Validate the match has not gotten started

  end
end
