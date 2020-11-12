defmodule StakeLaneApi.Fixture do
  @moduledoc """
  The Fixture context.
  """

  import Ecto.Query, warn: false
  alias StakeLaneApi.Repo
  alias StakeLaneApi.Football.Fixture
  alias StakeLaneApi.Football.Fixture.Status

  def get_fixture_by_third_id(third_api, third_fixture_id) do
    query = from f in Fixture,
      where: fragment(
        "third_parties_info @> ?",
        ^[%{"api" => third_api, "fixture_id" => third_fixture_id}]
      )

    query
    |> Repo.one()
  end


  def get_fixtures_to_update_results(third_api) do
    # https://hexdocs.pm/ecto/Ecto.Query.API.html#datetime_add/3
    query = from f in Fixture,
      select: merge(f, %{
        third_party_info: fragment("third_parties_info -> 0")
      }),
      where:
        f.starts_at_iso_date > datetime_add(^NaiveDateTime.utc_now(), -5, "hour") and
        f.starts_at_iso_date < datetime_add(^NaiveDateTime.utc_now(), +15, "minute") and
        f.status_code not in ^Status.finished_status_codes() and
        fragment("third_parties_info @> ?", ^[%{"api" => third_api}]),
      order_by:
        [asc: f.starts_at_iso_date]

    query
    |> Repo.all()
  end

  def get_my_fixtures(user_id) do
    query = from fixtures in Fixture,
      inner_join: league in assoc(fixtures, :league),
      inner_join: user_league in assoc(league, :user_league),
      inner_join: home_team in assoc(fixtures, :home_team),
      inner_join: away_team in assoc(fixtures, :away_team),
      inner_join: home_country in assoc(home_team, :country),
      inner_join: away_country in assoc(away_team, :country),
      where:
        fixtures.starts_at_iso_date > datetime_add(^NaiveDateTime.utc_now(), -5, "day") and
        fixtures.starts_at_iso_date < datetime_add(^NaiveDateTime.utc_now(), +0, "day") and
        user_league.user_id == ^user_id,
      order_by:
        [asc: fixtures.starts_at_iso_date],
      preload: [
        home_team: {
          home_team,
          country: home_country
        },
        away_team: {
          away_team,
          country: away_country
        }
      ]

    query
    |> Repo.all()
  end

  @doc """
  Updates a fixture.

  ## Examples

      iex> update_fixture(fixture, %{field: new_value})
      {:ok, %Fixture{}}

      iex> update_fixture(fixture, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fixture(%Fixture{} = fixture, attrs) do
    fixture
    |> Fixture.changeset(attrs)
    |> Repo.update()
  end

  def create_fixture(attrs \\ %{}) do
    %Fixture{}
    |> Fixture.changeset(attrs)
    |> Repo.insert()
  end
end
