defmodule StakeLaneApi.UserLeague do
  @moduledoc """
  The UserLeague context.
  """

  import Ecto.Query, warn: false
  import StakeLaneApiWeb.Gettext
  alias StakeLaneApi.Repo
  alias StakeLaneApi.Links.UserLeague
  alias StakeLaneApi.Links.UserTeamLeague
  alias StakeLaneApi.Football.Fixture
  alias StakeLaneApi.Helpers.Errors
  alias StakeLaneApi.UserPlan

  def get_user_leagues(user_id) do
    get_user_championship_leagues(user_id) ++ get_user_team_leagues(user_id)
  end

  def get_user_championship_leagues(user_id) do
    query = from ul in UserLeague,
      inner_join: league in assoc(ul, :league),
      inner_join: country in assoc(league, :country),
      left_join: fixtures in assoc(league, :fixtures),
      left_join: prediction in assoc(fixtures, :prediction),
      group_by: [ ul.id, league.id, country.id ],
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
    |> Repo.all
  end

  def get_user_team_leagues(user_id) do
    query = from utl in UserTeamLeague,
      inner_join: team in assoc(utl, :team),
      inner_join: country in assoc(team, :country),
      left_join: fixture in Fixture,
        on: utl.team_id == fixture.home_team_id or utl.team_id == fixture.away_team_id,
      left_join: prediction in assoc(fixture, :prediction),
      group_by: [ utl.id, team.id, country.id ],
      where:
        utl.user_id == ^user_id,
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
    |> Repo.all
  end

  def create_user_league(_, nil, nil), do: {:error, "No league_id/team_id has been sent"}
  def create_user_league(user_id, league_id, nil) do
    with user_plan <- UserPlan.get_user_plan(user_id),
      {:ok, plan_limits} <- UserPlan.get_user_plan_limits(user_plan),
      user_leagues <- get_how_many_active_leagues_user_has(user_id) do

      case allow_to_add_more_leagues(plan_limits, user_leagues) do
        false -> dgettext("errors", "Your slots are full, you can't add more leagues") |> Errors.treated_error
        true ->
          attrs = %{ user_id: user_id, league_id: league_id }

          %UserLeague{}
          |> UserLeague.changeset(attrs)
          |> Repo.insert()
      end
    end
  end
  def create_user_league(user_id, nil, team_id) do
    # TODO: Check if user has slots to participate on a new team-league
    attrs = %{
      user_id: user_id,
      team_id: team_id,
    }

    %UserTeamLeague{}
    |> UserTeamLeague.changeset(attrs)
    |> Repo.insert()
  end

  defp allow_to_add_more_leagues(plan_limits, user_leagues) when user_leagues >= plan_limits, do: false
  defp allow_to_add_more_leagues(plan_limits, user_leagues) when user_leagues < plan_limits, do: true

  defp get_how_many_active_leagues_user_has(user_id) do
    user_league = (
      from ul in UserLeague,
      where: ul.user_id == ^user_id and ul.blocked == false
    )
    |> Repo.all
    |> length

    user_team_league = (
      from utl in UserTeamLeague,
      where: utl.user_id == ^user_id and utl.blocked == false
    )
    |> Repo.all
    |> length

    user_league + user_team_league
  end

  def user_plays_league?(user_id, fixture_id, blocked \\ false) do
    query = from ul in UserLeague,
      inner_join: league in assoc(ul, :league),
      inner_join: fixtures in assoc(league, :fixtures),
      where:
        ul.user_id == ^user_id and
        fixtures.id == ^fixture_id and
        ul.blocked == ^blocked

    query
    |> Repo.exists?
  end

  def user_plays_team_league?(user_id, fixture_id, blocked \\ false) do
    query = from fixture in StakeLaneApi.Football.Fixture,
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
    |> Repo.exists?
  end
end
