defmodule StakeLaneApiWeb.API.V1.Pool.PoolsControllerTest do
  use StakeLaneApiWeb.ConnCase
  import StakeLaneApi.Factory

  defp pool_asserted?(pool) do
    assert Map.has_key?(pool, "number_of_participants")
    assert Map.has_key?(pool, "participants")
    assert Map.has_key?(pool, "pool_info")
    assert Map.has_key?(pool["pool_info"], "name")
    assert Map.has_key?(pool["pool_info"], "id")

    pool["participants"]
    |> Stream.map(&participant_asserted?/1)
    |> Stream.run()

    pool
  end

  defp participant_asserted?(participant) do
    assert Map.has_key?(participant, "captain")
    assert Map.has_key?(participant, "blocked")
    assert Map.has_key?(participant, "id")
    assert Map.has_key?(participant, "user_id")
    assert Map.has_key?(participant, "user_name")
    assert Map.has_key?(participant, "first_name")
    assert Map.has_key?(participant, "last_name")
    assert Map.has_key?(participant, "picture")
    assert Map.has_key?(participant, "email")
    participant
  end

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
      pool_asserted?(pool)
    end
  end
end
