defmodule BolaoHubApi.Workers.UpdateLeagues do
  use Oban.Worker, queue: :events
  alias BolaoHubApi.League
  require Logger

  @doc """
    Updates Leagues information,
    Starting date, ending date, if it is still active, etc.
  """
  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    envs = Application.fetch_env!(:bolao_hub_api, :football_api)

    League.list_api_football_active_leagues
      |> Enum.map(&request_leagues(&1, envs))
      |> Enum.map(&update_leagues(&1))
    
    :ok
  end

  defp request_leagues(league, envs) do
    league_id = case league.third_parties_info |> Enum.find(&(&1.api == "api_football")) do 
      nil -> raise "#{league["name"]}-#{league["season"]} has no 3rd party league id"
      third_party_info -> third_party_info.league_id
    end
    
    url = "#{envs[:url]}/leagues/league/#{league_id}"
    headers = ["X-RapidAPI-Key": envs[:key]]
    response = HTTPoison.get!(url, headers)
    json = Jason.decode!(response.body)

    case is_binary json["api"]["error"] do
      true -> Logger.error("Error: #{json["api"]["error"]}") 
    end

    refreshed_league = json["api"]["leagues"]
      |> Enum.find(&(&1["league_id"] == league_id))

    %{
      "refreshed_league" => refreshed_league,
      "actual_league" => league,
    }
  end

  defp update_leagues(league) do
    today_date = Date.utc_today()
    refreshed_season_start = Date.from_iso8601!(league["refreshed_league"]["season_start"])
    refreshed_season_end = Date.from_iso8601!(league["refreshed_league"]["season_end"])

    is_active = case Date.diff(today_date, refreshed_season_end) do 
      diff_date when diff_date <= 0 -> true
      _ -> false
    end

    refreshed_attrs = %{
      is_active: is_active,
      season_start: refreshed_season_start,
      season_end: refreshed_season_end,
    }

    { :ok, _ } = League.update_league(league["actual_league"], refreshed_attrs)
  end
end