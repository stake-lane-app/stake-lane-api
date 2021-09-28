defmodule StakeLaneApiWeb.API.V1.Pool.PoolsControllerTest do
  use StakeLaneApiWeb.ConnCase
  import StakeLaneApi.Factory

  defp pool_asserted?(pool) do
    assert Map.has_key?(pool, "number_of_participants")
    assert Map.has_key?(pool, "participants")
    assert Map.has_key?(pool, "pool_info")
    assert Map.has_key?(pool, "about")
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
      team = insert(:team)

      insert(:user_league, league: league, user: user)
      insert(:user_team_league, team: team, user: user)
      participants = insert_list(4, :user)

      Enum.each(participants, fn participant ->
        insert(:user_league, league: league, user: participant)
        insert(:user_team_league, team: team, user: participant)
      end)

      authed_conn = Pow.Plug.assign_current_user(conn, user, [])

      {
        :ok,
        user: user,
        authed_conn: authed_conn,
        league: league,
        team: team,
        participants: participants
      }
    end

    test "with valid params, league pool", params do
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

    test "inviting user who doesn't play the league", params do
      %{
        authed_conn: authed_conn,
        league: league
      } = params

      user_who_doesnt_play_it = insert(:user)

      body = %{
        participant_ids: [user_who_doesnt_play_it.id],
        league_id: league.id,
        name: "Super Office Pool"
      }

      conn = post(authed_conn, Routes.api_v1_pools_path(authed_conn, :create), body)
      assert pool = json_response(conn, 201)
      pool_asserted?(pool)

      user_who_doesnt_play_it_has_been_added =
        pool["participants"]
        |> Enum.any?(fn participant -> participant["user_id"] === user_who_doesnt_play_it.id end)

      assert user_who_doesnt_play_it_has_been_added === false
    end

    test "creator doesn't play the league", params do
      %{
        authed_conn: authed_conn
      } = params

      league_creator_doesnt_play = insert(:league)

      body = %{
        participant_ids: [],
        league_id: league_creator_doesnt_play.id,
        name: "Some Name"
      }

      conn = post(authed_conn, Routes.api_v1_pools_path(authed_conn, :create), body)
      assert response = json_response(conn, 400)
      assert response["error"]["errors"] === "creator_doesnt_play_league"
    end

    test "with valid params, team pool", params do
      %{
        authed_conn: authed_conn,
        participants: participants,
        team: team
      } = params

      body = %{
        participant_ids: Enum.map(participants, fn participant -> participant.id end),
        team_id: team.id,
        name: "Fans of #{team.name}"
      }

      conn = post(authed_conn, Routes.api_v1_pools_path(authed_conn, :create), body)
      assert pool = json_response(conn, 201)
      pool_asserted?(pool)
    end

    test "inviting user who doesn't play the team league", params do
      %{
        authed_conn: authed_conn,
        team: team
      } = params

      user_who_doesnt_play_it = insert(:user)

      body = %{
        participant_ids: [user_who_doesnt_play_it.id],
        team_id: team.id,
        name: "Super Office Pool"
      }

      conn = post(authed_conn, Routes.api_v1_pools_path(authed_conn, :create), body)
      assert pool = json_response(conn, 201)
      pool_asserted?(pool)

      user_who_doesnt_play_it_has_been_added =
        pool["participants"]
        |> Enum.any?(fn participant -> participant["user_id"] === user_who_doesnt_play_it.id end)

      assert user_who_doesnt_play_it_has_been_added === false
    end

    test "creator doesn't play the team league", params do
      %{
        authed_conn: authed_conn
      } = params

      team_league_creator_doesnt_play = insert(:team)

      body = %{
        participant_ids: [],
        team_id: team_league_creator_doesnt_play.id,
        name: "Some Name"
      }

      conn = post(authed_conn, Routes.api_v1_pools_path(authed_conn, :create), body)
      assert response = json_response(conn, 400)
      assert response["error"]["errors"] === "creator_doesnt_play_league"
    end
  end
end
