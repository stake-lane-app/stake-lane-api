defmodule ApiFootball.GetLeagues do

  def get_league_id(api_football_league_id) do
    envs = Application.fetch_env!(:bolao_hub_api, :football_api)
    headers = ["X-RapidAPI-Key": envs[:key]]

    "#{envs[:url]}/leagues/league/#{api_football_league_id}"
      |> HTTPoison.get!(headers)
      |> (&(&1.body)).()
      |> Jason.decode!()
      |> (&(&1["api"]["leagues"])).()
      |> Enum.find(&(&1["league_id"] == api_football_league_id))
  end

  def parse_league_to_update(refreshed_league) do
    refreshed_season_end = refreshed_league["season_end"] |> Date.from_iso8601!
    %{
      is_active: Date.utc_today |> Date.diff(refreshed_season_end) |> is_league_active,
      season_start: refreshed_league["season_start"] |> Date.from_iso8601!,
      season_end: refreshed_season_end,
    }
  end

  defp is_league_active(diff_date) when diff_date <= 0, do: true
  defp is_league_active(_), do: false

end
