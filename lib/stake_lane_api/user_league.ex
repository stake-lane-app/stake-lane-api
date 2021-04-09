defmodule StakeLaneApi.UserLeague do
  @moduledoc """
  The UserLeague context.
  """

  import Ecto.Query, warn: false
  import StakeLaneApiWeb.Gettext
  alias StakeLaneApi.Repo
  alias StakeLaneApi.Links.{UserLeague, UserTeamLeague}
  alias StakeLaneApi.Football.Fixture
  alias StakeLaneApi.Helpers.Errors
  alias StakeLaneApi.UserPlan

  def get_user_leagues(user_id) do
    get_user_championship_leagues(user_id) ++ get_user_team_leagues(user_id)
  end

  def get_user_championship_leagues(user_id) do
    query =
      from ul in UserLeague,
        inner_join: league in assoc(ul, :league),
        inner_join: country in assoc(league, :country),
        left_join: fixtures in assoc(league, :fixtures),
        left_join: prediction in assoc(fixtures, :prediction),
        group_by: [ul.id, league.id, country.id],
        where: ul.user_id == ^user_id,
        select: %{
          blocked: ul.blocked,
          league_id: league.id,
          name: league.name,
          season: league.season,
          active: league.active,
          country: country,
          type: "league",
          total_score: sum(prediction.score)
        }

    query
    |> Repo.all()
  end

  def get_user_team_leagues(user_id) do
    query =
      from utl in UserTeamLeague,
        inner_join: team in assoc(utl, :team),
        inner_join: country in assoc(team, :country),
        left_join: fixture in Fixture,
        on: utl.team_id == fixture.home_team_id or utl.team_id == fixture.away_team_id,
        left_join: prediction in assoc(fixture, :prediction),
        group_by: [utl.id, team.id, country.id],
        where: utl.user_id == ^user_id,
        select: %{
          blocked: utl.blocked,
          team_id: team.id,
          name: team.name,
          logo: team.logo,
          is_national: team.is_national,
          founded: team.founded,
          country: country,
          type: "team",
          total_score: sum(prediction.score)
        }

    query
    |> Repo.all()
  end

  def user_plays_league?(user_id, fixture_id, blocked \\ false) do
    query =
      from ul in UserLeague,
        inner_join: league in assoc(ul, :league),
        inner_join: fixtures in assoc(league, :fixtures),
        where:
          ul.user_id == ^user_id and
            fixtures.id == ^fixture_id and
            ul.blocked == ^blocked

    query
    |> Repo.exists?()
  end

  def user_plays_team_league?(user_id, fixture_id, blocked \\ false) do
    query =
      from fixture in StakeLaneApi.Football.Fixture,
        left_join: home_team in assoc(fixture, :home_team),
        left_join: home_utl in assoc(home_team, :user_team_league),
        left_join: away_team in assoc(fixture, :away_team),
        left_join: away_utl in assoc(away_team, :user_team_league),
        where:
          home_utl.user_id == ^user_id and
            home_utl.blocked == ^blocked and
            fixture.id == ^fixture_id,
        or_where:
          away_utl.user_id == ^user_id and
            away_utl.blocked == ^blocked and
            fixture.id == ^fixture_id

    query
    |> Repo.exists?()
  end

  def who_plays_this_league(user_ids, league_id, blocked \\ false) do
    query =
      from ul in UserLeague,
        where:
          ul.user_id in ^user_ids and
            ul.league_id == ^league_id and
            ul.blocked == ^blocked

    query
    |> Repo.all()
  end

  def who_plays_this_team_league(user_ids, team_id, blocked \\ false) do
    query =
      from utl in UserTeamLeague,
        where:
          utl.user_id in ^user_ids and
            utl.team_id == ^team_id and
            utl.blocked == ^blocked

    query
    |> Repo.all()
  end

  def create_user_league(_, nil, nil), do: {:error, "No league_id/team_id has been sent"}

  def create_user_league(user_id, league_id, nil) do
    case can_user_create_it?(user_id, :leagues) do
      false ->
        dgettext("errors", "Your slots are full, you can't add more leagues")
        |> Errors.treated_error()

      true ->
        %UserLeague{}
        |> UserLeague.changeset(%{user_id: user_id, league_id: league_id})
        |> Repo.insert()
    end
  end

  def create_user_league(user_id, nil, team_id) do
    case can_user_create_it?(user_id, :team_leagues) do
      false ->
        dgettext("errors", "Your slots are full, you can't play this team-league")
        |> Errors.treated_error()

      true ->
        %UserTeamLeague{}
        |> UserTeamLeague.changeset(%{user_id: user_id, team_id: team_id})
        |> Repo.insert()
    end
  end

  defp can_user_create_it?(user_id, league_type) do
    with user_plan <- UserPlan.get_user_plan(user_id),
         {:ok, plan_limits} <- UserPlan.get_user_plan_limits(user_plan, league_type),
         user_leagues <- get_user_active_leagues(user_id, league_type) do
      under_the_limit?(plan_limits, user_leagues)
    end
  end

  defp under_the_limit?(plan_limits, user_leagues) when user_leagues >= plan_limits, do: false
  defp under_the_limit?(plan_limits, user_leagues) when user_leagues < plan_limits, do: true

  @spec get_user_active_leagues(integer, atom) :: integer
  defp get_user_active_leagues(user_id, :leagues), do: user_leagues_quantity(user_id)
  defp get_user_active_leagues(user_id, :team_leagues), do: user_team_leagues_quantity(user_id)

  defp user_leagues_quantity(user_id) do
    query =
      from ul in UserLeague,
        where: ul.user_id == ^user_id and ul.blocked == false

    query
    |> Repo.all()
    |> length
  end

  defp user_team_leagues_quantity(user_id) do
    query =
      from utl in UserTeamLeague,
        where: utl.user_id == ^user_id and utl.blocked == false

    query
    |> Repo.all()
    |> length
  end
end
