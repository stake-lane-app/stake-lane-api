defmodule StakeLaneApi.Team do
  @moduledoc """
  The Team context.
  """

  import Ecto.Query, warn: false
  alias StakeLaneApi.Repo
  alias StakeLaneApi.Football.Team

  def get_team_by_third_id(third_api, third_team_id) do
    query = from t in Team,
      where: fragment(
        "third_parties_info @> ?",
        ^[%{"api" => third_api, "team_id" => third_team_id}]
      )

    query
    |> Repo.one()
  end

  def list_teams(_, true) do
    query = from team in Team,
      inner_join: country in assoc(team, :country),
      where: team.is_national == ^true,
      select: %{ team | country: country },
      order_by: [ asc: team.name ]

    query
    |> Repo.all()
  end
  def list_teams(country_id, _) do
    query = from team in Team,
      inner_join: country in assoc(team, :country),
      where: team.country_id == ^country_id,
      select: %{ team | country: country },
      order_by: [
        desc: team.is_national,
        asc: team.name,
      ]

    query
    |> Repo.all()
  end

  def is_national?(team_id) do
    query = from team in Team,
    where:
      team.id == ^team_id and
      team.is_national == ^true

    query
    |> Repo.exists?
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  def list_leagues_a_team_plays(team_id) do
    query = from team in Team,
      inner_join: country in assoc(team, :country),
      left_join: fixture in StakeLaneApi.Football.Fixture,
        on: team.id == fixture.home_team_id or team.id == fixture.away_team_id,
      left_join: league in assoc(fixture, :league),
      left_join: country_league in assoc(league, :country),
      distinct: league.id,
      where:
        team.id == ^team_id and
        league.active == true,
      select: %{
        league_id: league.id,
        name: league.name,
        season: league.season,
        season_start: league.season_start,
        season_end: league.season_end,
        country: country_league,
       }

    query
    |> Repo.all
  end
end
