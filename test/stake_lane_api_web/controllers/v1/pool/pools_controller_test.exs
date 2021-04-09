defmodule StakeLaneApiWeb.API.V1.Pool.PoolsControllerTest do
  use StakeLaneApiWeb.ConnCase
  import StakeLaneApi.Factory

  describe "create/2" do
    setup %{conn: conn} do
      user = insert(:user)
      league = insert(:league)

      insert(:user_league, league: league, user: user)
      participants = insert_list(4, :user)

      Enum.each(participants, fn participant ->
        insert(:user_league, league: league, user: participant)
      end)

      authed_conn = Pow.Plug.assign_current_user(conn, user, [])

      {
        :ok,
        authed_conn: authed_conn, league: league, user: user, participants: participants
      }
    end

    test "with valid params", params do
      %{
        authed_conn: authed_conn,
        participants: participants,
        league: league
      } = params

      body = %{
        participant_ids: Enum.map(participants, fn participant -> participant.id end),
        league_id: league.id,
        name: "My Sweet Pool"
      }

      conn = post(authed_conn, Routes.api_v1_pools_path(authed_conn, :create), body)
      assert pool = json_response(conn, 201)
      # todo: Validated body response
    end
  end
end
