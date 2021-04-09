defmodule StakeLaneApi.Pool do
  @moduledoc """
  The Pool context.
  """

  import Ecto.Query, warn: false
  import StakeLaneApiWeb.Gettext
  alias StakeLaneApi.Helpers.Errors
  alias StakeLaneApi.UserLeague

  alias StakeLaneApi.Pools.Pool
  alias StakeLaneApi.Pools.PoolParticipant
  alias StakeLaneApi.Repo

  # Todos:
  # Check if every participant actually play that league or team
  # Have a filtered paticipant_id before inserting it at the pool_participant table
  # Return the participants from the created pool

  def create_pool(user_id, league_id, _, participant_ids, name) when is_number(league_id) do
    {:ok, pool} =
      %Pool{}
      |> Pool.changeset(%{name: name, league_id: league_id})
      |> Repo.insert()

    {_, participants} =
      ([user_id] ++ participant_ids)
      |> UserLeague.who_plays_this_league(league_id)
      |> Enum.map(fn verified_participant ->
        %{
          user_id: verified_participant.user_id,
          pool_id: pool.id,
          captain: user_id === verified_participant.user_id,
          inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
          updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
        }
      end)
      |> (&Repo.insert_all(PoolParticipant, &1, returning: true)).()

    created_pool =
      pool
      |> Map.merge(%{
        participants: participants,
        number_of_participants: length(participants)
      })

    {:ok, created_pool}
  end

  def create_pool(user_id, _, team_id, participant_ids, name) when is_number(team_id) do
    ([user_id] ++ participant_ids)
    |> UserLeague.who_plays_this_team_league(team_id)
  end

  def create_pool(_, _, _, _, _) do
    dgettext("errors", "A pool has to be based on a league or a team")
    |> Errors.treated_error()
  end
end
