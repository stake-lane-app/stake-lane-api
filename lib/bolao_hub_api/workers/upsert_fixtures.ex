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
  require Logger

  @third_api "api_football"

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    envs = Application.fetch_env!(:bolao_hub_api, :football_api)

    done = @third_api
    |> League.list_api_football_active_leagues
    |> parse_third_league_ids
    |> request_fixtures(envs)
    |> upsert_fixture()
    
    { :ok, done }
  end

  defp parse_third_league_ids(nil), do: ""
  defp parse_third_league_ids(leagues) do
    leagues
    |> Enum.map(fn league -> 
      league.third_parties_info
      |> Enum.find(&(&1.api == @third_api))
    end)
    |> Enum.reduce("", &("#{&1.league_id}-#{&2}"))
  end

  defp request_fixtures(league_ids, envs) do
    headers = ["X-RapidAPI-Key": envs[:key]]
    querystring = %{
      timezone: "UTC"
    }

    "#{envs[:url]}/fixtures/live/#{league_ids}"
    |> HTTPoison.get!(headers, querystring)
    |> (&(&1.body)).()
    |> Jason.decode!()
    |> (&(&1["api"]["fixtures"])).()

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
      event_date: fixture["event_date"] |> DateTime.from_iso8601(),
      event_timestamp: fixture["event_timestamp"],
      status: fixture["status"],
      status_short: fixture["statusShort"],
      elapsed: fixture["elapsed"],
      venue: fixture["venue"],
      referee: fixture["referee"],
      score: fixture["score"] |> parse_score,
    }

    new_fixture
    |> Fixture.create_fixture()
  end

  defp update_fixture(fixture, refreshed_fixture) do
    updated_fixture = %{
      goals_home_team: refreshed_fixture["goalsHomeTeam"],
      goals_away_team: refreshed_fixture["goalsAwayTeam"],
      event_date: refreshed_fixture["event_date"] |> DateTime.from_iso8601(),
      event_timestamp: refreshed_fixture["event_timestamp"],
      status: refreshed_fixture["status"],
      status_short: refreshed_fixture["statusShort"],
      elapsed: refreshed_fixture["elapsed"],
      venue: refreshed_fixture["venue"],
      referee: refreshed_fixture["referee"],
      score: refreshed_fixture["score"] |> parse_score,
    }
    
    fixture
    |> Fixture.update_fixture(updated_fixture)
  end

  defp parse_score(fixture) do
    %{
      halftime: fixture["halftime"],
      fulltime: fixture["fulltime"],
      extratime: fixture["extratime"],
      penalty: fixture["penalty"],
    }
  end
end
