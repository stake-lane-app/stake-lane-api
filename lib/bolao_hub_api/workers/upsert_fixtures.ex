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
  alias ApiFootball.ApiFixtures

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
    |> ApiFixtures.get_fixtures_by_league_id()
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
    league_id = @third_api |> League.get_league_by_third_id(fixture["league_id"]) |> Map.get(:id)
    home_team_id = @third_api |> Team.get_team_by_third_id(fixture["homeTeam"]["team_id"]) |> Map.get(:id)
    away_team_id = @third_api |> Team.get_team_by_third_id(fixture["awayTeam"]["team_id"]) |> Map.get(:id)

    new_fixture = fixture |> ApiFixtures.parse_fixture_to_creation(league_id, home_team_id, away_team_id)
    {:ok, _} = new_fixture |> Fixture.create_fixture
  end

  defp update_fixture(fixture, refreshed_fixture) do
    updated_fixture = refreshed_fixture |> ApiFixtures.parse_fixture_to_update
    {:ok, _} = fixture |> Fixture.update_fixture(updated_fixture)
  end

end
