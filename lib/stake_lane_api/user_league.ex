defmodule StakeLaneApi.UserLeague do
  @moduledoc """
  The UserLeague context.
  """

  import Ecto.Query, warn: false
  alias StakeLaneApi.Repo
  alias StakeLaneApi.Links.UserLeague

  def get_user_leagues(user_id) do
    query = from ul in UserLeague,
      inner_join: league in assoc(ul, :league),
      inner_join: country in assoc(league, :country),
      where: ul.user_id == ^user_id,
      select: %{
        league_id: league.id,
        name: league.name,
        season: league.season,
        active: league.active,
        country: country,
      }

    Repo.all query
  end

  def get_user_leagues_id(user_id) do
    query = from ul in UserLeague,
      where: ul.user_id == ^user_id,
      select: ul.league_id

    Repo.all query
  end

  def create_user_league(user_id, league_id) do
    # TODO: Check if user has slots to participate on a new league
    attrs = %{
      user_id: user_id,
      league_id: league_id,
    }

    %UserLeague{}
    |> UserLeague.changeset(attrs)
    |> Repo.insert()
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
    |> Repo.one
  end
end
