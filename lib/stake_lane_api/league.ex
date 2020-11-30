defmodule StakeLaneApi.League do
  @moduledoc """
  The League context.
  """

  import Ecto.Query, warn: false
  alias StakeLaneApi.Repo
  alias StakeLaneApi.Football.League

  def list_active_leagues_by_third_api(third_api) do
    query = from l in League,
      select: merge(l, %{
        third_party_info: fragment("third_parties_info -> 0")
      }),
      where:
        l.active == true and
        fragment("third_parties_info @> ?", ^[%{"api" => third_api}])

    query
    |> Repo.all()
  end

  def get_league_by_third_id(third_api, third_league_id) do
    query = from l in League,
      where: fragment(
        "third_parties_info @> ?",
        ^[%{"api" => third_api, "league_id" => third_league_id}]
      )

    query
    |> Repo.one()
  end

  def list_leagues() do
    query = from league in League,
      inner_join: country in assoc(league, :country),
      select: %{
        league_id: league.id,
        name: league.name,
        season: league.season,
        active: league.active,
        country: country,
      },
      order_by:
        [asc: country.name]

    Repo.all query
  end

  @doc """
  Updates a league.

  ## Examples

      iex> update_league(league, %{field: new_value})
      {:ok, %League{}}

      iex> update_league(league, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_league(%League{} = league, attrs) do
    league
    |> League.changeset(attrs)
    |> Repo.update()
  end

end
