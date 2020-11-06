defmodule BolaoHubApi.Workers.UpsertFixtures do
  @moduledoc """
    Upsert Fixtures,
    Starting date, hour,
    Clubs,
    Venue
  """

  use Oban.Worker, queue: :events
  alias BolaoHubApi.League
  alias BolaoHubApi.Team
  alias BolaoHubApi.Fixture
  alias ApiFootball.GetFixtures

  @third_api "api_football"

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    done = @third_api
    |> League.list_active_leagues_by_third_api
    |> Enum.map(&request_fixture(&1))
    |> Enum.map(&upsert_fixture(&1))

    { :ok, done }
  end

  defp request_fixture(league) do
    league.third_party_info["league_id"]
    |> GetFixtures.get_fixture_by_league_id()
  end

  defp upsert_fixture(refreshed_fixtures) do
    refreshed_fixtures
    |> Enum.map(fn refreshed_fixture ->

      Fixture.get_fixture_by_third_id(@third_api, refreshed_fixture["fixture_id"])
      |> case  do
        nil -> create_fixture(refreshed_fixture)
        current_fixture -> update_fixture(current_fixture, refreshed_fixture)
      end

    end)
  end

  defp create_fixture(fixture) do
    {:ok, starts_at_iso_date, _} = fixture["event_date"] |> DateTime.from_iso8601

    new_fixture = %{
      league_id: @third_api |> League.get_league_by_third_id(fixture["league_id"]) |> Map.get(:id),
      home_team_id: @third_api |> Team.get_team_by_third_id(fixture["homeTeam"]["team_id"]) |> Map.get(:id),
      away_team_id: @third_api |> Team.get_team_by_third_id(fixture["awayTeam"]["team_id"]) |> Map.get(:id),
      third_parties_info: [
        %{
          api: @third_api,
          fixture_id: fixture["fixture_id"],
          league_id: fixture["league_id"],
          round: fixture["fixture_id"],
        }
      ],

      goals_home_team: fixture["goalsHomeTeam"],
      goals_away_team: fixture["goalsAwayTeam"],
      starts_at_iso_date: starts_at_iso_date,
      event_timestamp: fixture["event_timestamp"],
      status: fixture["status"],
      status_code: fixture["statusShort"],
      elapsed: fixture["elapsed"],
      venue: fixture["venue"],
      referee: fixture["referee"],
      score: fixture["score"] |> GetFixtures.parse_score,
    }

    {:ok, _} = new_fixture |> Fixture.create_fixture()
  end

  defp update_fixture(fixture, refreshed_fixture) do
    updated_fixture = refreshed_fixture |> GetFixtures.parse_fixture_to_update()

    fixture
    |> Fixture.update_fixture(updated_fixture)
  end

end
