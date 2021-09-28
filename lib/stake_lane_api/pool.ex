defmodule StakeLaneApi.Pool do
  @moduledoc """
  The Pool context.
  """

  import Ecto.Query, warn: false
  import StakeLaneApiWeb.Gettext
  alias StakeLaneApi.Helpers.Errors
  alias StakeLaneApi.Pools
  alias StakeLaneApi.Pools.Pool
  alias StakeLaneApi.UserLeague
  alias StakeLaneApi.User
  alias StakeLaneApi.UserPlan
  alias StakeLaneApi.League
  alias StakeLaneApi.Team
  alias StakeLaneApi.PoolParticipant
  alias StakeLaneApi.Repo

  def create_pool(_, nil, nil, _, _) do
    dgettext("errors", "A pool has to be based on a league or a team")
    |> Errors.treated_error()
  end

  def create_pool(user_id, league_id, team_id, participant_ids, name) do
    # TODOs: Check if user_id and participants have slots on its pool plan (Before the creation)

    Repo.transaction(fn repo ->
      {:ok, pool} =
        %Pool{}
        |> Pool.changeset(%{name: name, league_id: league_id})
        |> repo.insert()

      participants =
        Enum.concat([user_id], participant_ids)
        |> who_plays_this_league(league_id, team_id)
        |> does_creator_play_it?(user_id, repo)
        |> remove_participants_with_no_free_spot()
        |> Enum.map(&parse_participant_to_insert(&1, pool, user_id))
        |> (&repo.insert_all(Pools.PoolParticipant, &1, returning: true)).()
        |> (fn {_, participants} -> get_participants_data(participants) end).()

      %{
        pool_info: pool,
        about: get_pool_about(league_id, team_id),
        participants: participants,
        number_of_participants: length(participants)
      }
    end)
  end

  defp who_plays_this_league(participant_ids, league_id, _team_id) when is_number(league_id) do
    UserLeague.who_plays_this_league(participant_ids, league_id)
  end

  defp who_plays_this_league(participant_ids, _league_id, team_id) when is_number(team_id) do
    UserLeague.who_plays_this_team_league(participant_ids, team_id)
  end

  defp get_pool_about(league_id, _) when not is_nil(league_id) do
    league = League.get_league!(league_id)
    "#{league.name} #{league.season}"
  end

  defp get_pool_about(_, team_id) when not is_nil(team_id) do
    team = Team.get_team!(team_id)
    team.name
  end

  defp does_creator_play_it?(verified_participants, user_creator_id, repo) do
    verified_participants
    |> Enum.find(fn verified_participant -> verified_participant.user_id === user_creator_id end)
    |> case do
      nil -> repo.rollback(:creator_doesnt_play_league)
      _ -> verified_participants
    end
  end

  defp remove_participants_with_no_free_spot(verified_participants) do
    verified_participants
    |> Enum.filter(fn verified_participant ->
      UserPlan.get_user_plan(verified_participant.user_id)
      |> UserPlan.get_user_plan_limits(:pools)
      |> (fn {:ok, plan_limit} ->
            user_pools = PoolParticipant.user_pools_quantity(verified_participant.user_id)
            under_the_limit?(plan_limit, user_pools)
          end).()
    end)
  end

  defp under_the_limit?(plan_limit, user_leagues) when user_leagues >= plan_limit, do: false
  defp under_the_limit?(plan_limit, user_leagues) when user_leagues < plan_limit, do: true

  defp parse_participant_to_insert(verified_participant, pool, user_creator_id) do
    %{
      user_id: verified_participant.user_id,
      pool_id: pool.id,
      captain: user_creator_id === verified_participant.user_id,
      inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
      updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    }
  end

  defp get_participants_data(participants) do
    participants
    |> Stream.map(fn participant ->
      participant_filtered = %{
        user_id: participant.user_id,
        captain: participant.captain,
        blocked: participant.blocked,
        id: participant.id
      }

      participant.user_id
      |> User.get_user_by_id()
      |> Map.merge(participant_filtered)
    end)
    |> Enum.to_list()
  end
end
