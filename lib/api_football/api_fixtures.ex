defmodule ApiFootball.ApiFixtures do
  @moduledoc false

  def get_fixtures_by_league_id(api_football_league_id) do
    envs = Application.fetch_env!(:bolao_hub_api, :football_api)
    headers = ["X-RapidAPI-Key": envs[:key]]

    "#{envs[:url]}/fixtures/league/#{api_football_league_id}"
    |> HTTPoison.get!(headers)
    |> (&(&1.body)).()
    |> Jason.decode!()
    |> (&(&1["api"]["fixtures"])).()
  end

  def get_fixture_by_id(api_football_fixture_id) do
    envs = Application.fetch_env!(:bolao_hub_api, :football_api)
    headers = ["X-RapidAPI-Key": envs[:key]]

    "#{envs[:url]}/fixtures/id/#{api_football_fixture_id}"
    |> HTTPoison.get!(headers)
    |> (&(&1.body)).()
    |> Jason.decode!()
    |> (&(&1["api"]["fixtures"])).()
  end

  def parse_fixture_to_creation(fixture, league_id, home_team_id, away_team_id) do
    fixture
    |> updatable_fields
    |> Map.merge(%{
      league_id: league_id,
      home_team_id: home_team_id,
      away_team_id: away_team_id,
      third_parties_info: [
        %{
          api: "api_football",
          fixture_id: fixture["fixture_id"],
          league_id: fixture["league_id"],
          round: fixture["fixture_id"],
        }
      ],
    })
  end

  def parse_fixture_to_update(refreshed_fixture) do
    refreshed_fixture |> updatable_fields
  end

  defp updatable_fields(fixture) do
    %{
      goals_home_team: fixture["goalsHomeTeam"],
      goals_away_team: fixture["goalsAwayTeam"],
      starts_at_iso_date: fixture["event_date"] |> get_start_date,
      event_timestamp: fixture["event_timestamp"],
      status: fixture["status"],
      status_code: fixture["statusShort"],
      elapsed: fixture["elapsed"],
      venue: fixture["venue"],
      referee: fixture["referee"],
      score: fixture["score"] |> parse_score,
    }
  end

  defp parse_score(fixture) do
    %{
      halftime: fixture["halftime"],
      fulltime: fixture["fulltime"],
      extratime: fixture["extratime"],
      penalty: fixture["penalty"],
    }
  end

  defp get_start_date(event_date) do
    {:ok, starts_at_iso_date, _} = event_date |> DateTime.from_iso8601()

    starts_at_iso_date
  end
end
