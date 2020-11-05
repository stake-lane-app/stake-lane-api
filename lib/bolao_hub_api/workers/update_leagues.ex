defmodule BolaoHubApi.Workers.UpdateLeagues do
  @moduledoc """
    Updates Leagues information,
    Starting date, ending date, if it is still active, etc.
  """

  use Oban.Worker, queue: :events
  alias BolaoHubApi.League
  alias BolaoHubApi.Leagues.ThirdPartyInfo
  require Logger

  @third_api "api_football"

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    envs = Application.fetch_env!(:bolao_hub_api, :football_api)

    done = @third_api
    |> League.list_api_football_active_leagues
    |> Enum.map(&request_league(&1, envs))
    |> Enum.map(&update_league(&1))
    
    { :ok, done }
  end

  defp request_league(league, envs) do
    %ThirdPartyInfo{ league_id: third_party_league_id } = league.third_parties_info
      |> Enum.find(&(&1.api == @third_api))

    headers = ["X-RapidAPI-Key": envs[:key]]
    refreshed_league = "#{envs[:url]}/leagues/league/#{third_party_league_id}"
      |> HTTPoison.get!(headers)
      |> (&(&1.body)).()
      |> Jason.decode!()
      |> (&(&1["api"]["leagues"])).()
      |> Enum.find(&(&1["league_id"] == third_party_league_id))

    %{
      "actual_league" => league,
      "refreshed_league" => refreshed_league,
    }
  end

  defp update_league(league) do
    refreshed_season_start = Date.from_iso8601!(league["refreshed_league"]["season_start"])
    refreshed_season_end = Date.from_iso8601!(league["refreshed_league"]["season_end"])

    is_active = Date.utc_today()
      |> Date.diff(refreshed_season_end)
      |> is_league_active()

    refreshed_attrs = %{
      is_active: is_active,
      season_start: refreshed_season_start,
      season_end: refreshed_season_end,
    }

    { :ok, _ } = League.update_league(league["actual_league"], refreshed_attrs)
  end

  defp is_league_active(diff_date) when diff_date <= 0, do: true
  defp is_league_active(_), do: false
end