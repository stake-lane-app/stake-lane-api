defmodule ApiFootball.GetFixtures do

  def get_fixture_by_league_id(api_football_league_id) do
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

  def parse_fixture_to_update(refreshed_fixture) do
    {:ok, starts_at_iso_date, _} = refreshed_fixture["event_date"] |> DateTime.from_iso8601

    %{
      goals_home_team: refreshed_fixture["goalsHomeTeam"],
      goals_away_team: refreshed_fixture["goalsAwayTeam"],
      starts_at_iso_date: starts_at_iso_date,
      event_timestamp: refreshed_fixture["event_timestamp"],
      status: refreshed_fixture["status"],
      status_code: refreshed_fixture["statusShort"],
      elapsed: refreshed_fixture["elapsed"],
      venue: refreshed_fixture["venue"],
      referee: refreshed_fixture["referee"],
      score: refreshed_fixture["score"] |> parse_score,
    }
  end

  def parse_score(fixture) do
    %{
      halftime: fixture["halftime"],
      fulltime: fixture["fulltime"],
      extratime: fixture["extratime"],
      penalty: fixture["penalty"],
    }
  end

end
