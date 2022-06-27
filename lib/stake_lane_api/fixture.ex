defmodule StakeLaneApi.Fixture do
  @moduledoc """
  The Fixture context.
  """

  import Ecto.Query, warn: false
  alias StakeLaneApi.Repo
  alias StakeLaneApi.Users.Prediction
  alias StakeLaneApi.Links.UserTeamLeague
  alias StakeLaneApi.Football.Fixture
  alias StakeLaneApi.Football.Fixture.Status

  def get_fixture_by_id(fixture_id) do
    query =
      from f in Fixture,
        where: f.id == ^fixture_id

    query
    |> Repo.one()
  end

  def get_fixture_by_third_id(third_api, third_fixture_id) do
    query =
      from f in Fixture,
        where:
          fragment(
            "third_parties_info @> ?",
            ^[%{"api" => third_api, "fixture_id" => third_fixture_id}]
          )

    query
    |> Repo.one()
  end

  def get_fixtures_to_update_results(third_api) do
    # https://hexdocs.pm/ecto/Ecto.Query.API.html#datetime_add/3
    query =
      from f in Fixture,
        select:
          merge(f, %{
            third_party_info: fragment("third_parties_info -> 0")
          }),
        where:
          f.starts_at_iso_date > datetime_add(^NaiveDateTime.utc_now(), -5, "hour") and
            f.starts_at_iso_date < datetime_add(^NaiveDateTime.utc_now(), +15, "minute") and
            f.status_code not in ^Status.finished_status_codes() and
            fragment("third_parties_info @> ?", ^[%{"api" => third_api}]),
        order_by: [asc: f.starts_at_iso_date]

    query
    |> Repo.all()
  end

  def get_my_fixtures(user_id, user_tz \\ "UTC", page \\ 0, page_size \\ 10) do
    query =
      from fixture in Fixture,
        inner_join: league in assoc(fixture, :league),
        inner_join: league_country in assoc(league, :country),
        inner_join: home_team in assoc(fixture, :home_team),
        inner_join: away_team in assoc(fixture, :away_team),
        left_join: home_country in assoc(home_team, :country),
        left_join: away_country in assoc(away_team, :country),
        left_join: user_league in assoc(league, :user_league),
        left_join: user_team_league in UserTeamLeague,
        on: user_team_league.team_id == home_team.id or user_team_league.team_id == away_team.id,
        left_join: prediction in Prediction,
        on: prediction.user_id == ^user_id and prediction.fixture_id == fixture.id,
        where:
          user_league.user_id == ^user_id and
            user_league.blocked == false,
        or_where:
          user_team_league.user_id == ^user_id and
            user_team_league.blocked == false,
        select: %{
          fixture
          | prediction: prediction,
            league: %{
              league_id: league.id,
              name: league.name,
              season: league.season,
              country_name: league_country.name,
              country_flag: league_country.flag
            }
        },
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

    beginning_of_the_user_day =
      user_tz
      |> Timex.now()
      |> Timex.beginning_of_day()

    offset =
      page
      |> get_page()
      |> get_offset(page_size)

    query
    |> filter_fixtures(page, beginning_of_the_user_day)
    |> limit(^page_size)
    |> offset(^offset)
    |> Repo.all()
    |> maybe_reverse(page)
  end

  # For today and future fixtures:
  defp filter_fixtures(queryable, page, beginning_of_the_user_day) when page >= 0 do
    queryable
    |> where(
      [fixture],
      fixture.starts_at_iso_date > ^beginning_of_the_user_day
    )
    |> order_by(asc: :starts_at_iso_date)
  end

  # For past fixtures:
  defp filter_fixtures(queryable, page, beginning_of_the_user_day) when page < 0 do
    queryable
    |> where(
      [fixture],
      fixture.starts_at_iso_date < ^beginning_of_the_user_day
    )
    |> order_by(desc: :starts_at_iso_date)
  end

  defp maybe_reverse(fixtures, page) when page < 0, do: fixtures |> Enum.reverse()
  defp maybe_reverse(fixtures, _), do: fixtures

  defp get_page(-1), do: 0
  defp get_page(page) when page >= 0, do: page
  defp get_page(page) when page <= -2, do: Kernel.abs(page) - 1

  defp get_offset(0, _page_size), do: 0
  defp get_offset(page, page_size), do: page * page_size + 1

  def update_fixture!(%Fixture{} = fixture, attrs) do
    fixture
    |> Fixture.changeset(attrs)
    |> Repo.update!()
  end

  def create_fixture(attrs \\ %{}) do
    %Fixture{}
    |> Fixture.changeset(attrs)
    |> Repo.insert()
  end
end
