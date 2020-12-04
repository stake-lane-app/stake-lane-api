defmodule StakeLaneApi.UserTeam do
  @moduledoc """
  The UserLeague context.
  """

  import Ecto.Query, warn: false
  import StakeLaneApiWeb.Gettext
  alias StakeLaneApi.Repo
  alias StakeLaneApi.Links.UserTeam
  alias UserTeam.Level, as: TeamLevel
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
    |> are_team_and_level_nationals?(level)
    |> case do
      {false, _} -> {:ok, :not_national_team}
      {true, true} -> {:ok, true}
      _ -> dgettext("errors", "The team needs to be national") |> Errors.treated_error
    end
  end

  defp are_team_and_level_nationals?(team_id, level) do
    {Team.is_national?(team_id), level === TeamLevel.team_levels.national}
  end

  defp validate_duplicated(user_id, team_id) do
    user_id
    |> already_supports_team?(team_id)
    |> case do
      true -> dgettext("errors", "You already support this team") |> Errors.treated_error
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

  defp already_supports_team?(user_id, team_id) do
    query = from ut in UserTeam,
    where:
      ut.user_id == ^user_id and
      ut.team_id == ^team_id

    query
    |> Repo.exists?
  end

  def delete_user_team_by_level(user_id, level) do
    UserTeam
    |> Repo.get_by(%{user_id: user_id, level: level})
    |> case do
      nil -> dgettext("errors", "We've not found any team preference at this level") |> Errors.treated_error
      user_team -> Repo.delete(user_team)
    end
  end
end
