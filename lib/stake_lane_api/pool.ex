defmodule StakeLaneApi.Pool do
  @moduledoc """
  The Pool context.
  """

  import Ecto.Query, warn: false
  import StakeLaneApiWeb.Gettext
  alias StakeLaneApi.Helpers.Errors
  alias StakeLaneApi.UserLeague
  alias StakeLaneApi.User
  # alias StakeLaneApi.UserPlan
  alias StakeLaneApi.Pools.Pool
  alias StakeLaneApi.League
  alias StakeLaneApi.Team
  alias StakeLaneApi.Pools.PoolParticipant
  alias StakeLaneApi.Repo

  # Todos:
  # Check if every participant actually play that league or team
  # Have a filtered paticipant_id before inserting it at the pool_participant table
  # Return the participants from the created pool

  def create_pool(user_id, league_id, _, participant_ids, name) when is_number(league_id) do
    # TODOs: Check if user_id and participants have slots on its pool plan (Before the creation)

    Repo.transaction(fn repo ->
      league = League.get_league!(league_id)

      {:ok, pool} =
        %Pool{}
        |> Pool.changeset(%{name: name, league_id: league_id})
        |> repo.insert()

      participants =
        [user_id]
        |> Enum.concat(participant_ids)
        |> UserLeague.who_plays_this_league(league_id)
        |> does_creator_play_it?(league_id, user_id, repo)
        |> Enum.map(&parse_participant_to_insert(&1, pool, user_id))
        |> (&repo.insert_all(PoolParticipant, &1, returning: true)).()
        |> (fn {_, participants} -> get_participants_data(participants) end).()

      %{
        pool_info: pool,
        about: "#{league.name} #{league.season}",
        participants: participants,
        number_of_participants: length(participants)
      }
    end)
  end

  def create_pool(user_id, _, team_id, participant_ids, name) when is_number(team_id) do
    Repo.transaction(fn repo ->
      team = Team.get_team!(team_id)

      {:ok, pool} =
        %Pool{}
        |> Pool.changeset(%{name: name, team_id: team_id})
        |> repo.insert()

      participants =
        [user_id]
        |> Enum.concat(participant_ids)
        |> UserLeague.who_plays_this_team_league(team_id)
        |> does_creator_play_it?(team_id, user_id, repo)
        |> Enum.map(&parse_participant_to_insert(&1, pool, user_id))
        |> (&repo.insert_all(PoolParticipant, &1, returning: true)).()
        |> (fn {_, participants} -> get_participants_data(participants) end).()

      %{
        pool_info: pool,
        about: team.name,
        participants: participants,
        number_of_participants: length(participants)
      }
    end)
  end

  def create_pool(_, _, _, _, _) do
    dgettext("errors", "A pool has to be based on a league or a team")
    |> Errors.treated_error()
  end

  defp does_creator_play_it?(verified_participants, league_id, user_creator_id, repo) do
    verified_participants
    |> Enum.find(fn verified_participant -> verified_participant.user_id === user_creator_id end)
    |> case do
      nil -> repo.rollback(:creator_doesnt_play_league)
      _ -> verified_participants
    end
  end

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
