defmodule BolaoHubApi.Workers.UpsertFixtures do
  @moduledoc """
    Upsert Fixtures,
    Starting date, hour,
    Clubs,
    Venue
  """

  use Oban.Worker, queue: :events
  alias BolaoHubApi.League
  require Logger

  @third_api "api_football"

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    envs = Application.fetch_env!(:bolao_hub_api, :football_api)

    done = @third_api
    |> League.list_api_football_active_leagues
    |> parse_third_league_ids
    |> request_fixtures(envs)
    
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
    |> IO.inspect(label: "response")
    # |> (&(&1.body)).()
    # |> Jason.decode!()
    # |> (&(&1["api"]["countries"])).()
  end

end



