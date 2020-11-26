defmodule StakeLaneApi.UserTeam do
  @moduledoc """
  The UserLeague context.
  """

  import Ecto.Query, warn: false
  import StakeLaneApiWeb.Gettext
  alias StakeLaneApi.Repo
  alias StakeLaneApi.Links.UserTeam
  alias StakeLaneApi.Team
  alias StakeLaneApi.Helpers.Errors

  def get_user_teams(user_id) do
    query = from user_team in UserTeam,
      inner_join: team in assoc(user_team,  :team),
      inner_join: country in assoc(team, :team),
      where: user_team.user_id == ^user_id,
      select: %{
        level: user_team.level,
        team_id: team.team_id,
        name: team.name,
        full_name: team.full_name,
        logo: team.logo,
        is_national: team.is_national,
        founded: team.founded,
        venue: team.venue,
        country: country,
      }

    Repo.all query
  end

  def upsert_user_team(user_id, team_id, level) do
    with level_taken <- get_user_level(user_id, level),
        {:ok, _} <- validate_national(team_id, level),
        {:ok, _} <- validate_duplicated(user_id, team_id),
        {:ok, upserted} <- upsert_user_team_(user_id, team_id, level, level_taken) do

      {:ok, upserted}
    end
  end

  defp upsert_user_team_(user_id, team_id, level, nil) do
    %UserTeam{}
    |> UserTeam.changeset(%{
      user_id: user_id,
      team_id: team_id,
      level: level,
    })
    |> Repo.insert()
  end
  defp upsert_user_team_(_, team_id, _, %UserTeam{} = user_level) do
    user_level
    |> UserTeam.changeset(%{ team_id: team_id })
    |> Repo.update()
  end

  defp validate_national(team_id, level) do
    team_id
    |> (&( Team.is_national?(&1) and UserTeam.Level.team_levels.national != level)).()
    |> case do
      true -> dgettext("errors", "The team needs to be national") |> Errors.treated_error
      false -> {:ok, false}
    end
  end

  defp validate_duplicated(user_id, team_id) do
    user_id
    |> get_user_team(team_id)
    |> case do
      true -> dgettext("errors", "You cannot add the same team on more than one level") |> Errors.treated_error
      false -> {:ok, false}
    end
  end

  defp get_user_level(user_id, level) do
    query = from ut in UserTeam,
    where:
      ut.user_id == ^user_id and
      ut.level == ^level

    query
    |> Repo.one()
  end

  defp get_user_team(user_id, team_id) do
    query = from ut in UserTeam,
    where:
      ut.user_id == ^user_id and
      ut.team_id == ^team_id

    query
    |> Repo.exists?
  end
end
