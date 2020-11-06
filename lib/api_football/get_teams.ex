defmodule ApiFootball.GetTeams do

  def get_team_by_league_id(api_football_league_id) do
    envs = Application.fetch_env!(:bolao_hub_api, :football_api)
    headers = ["X-RapidAPI-Key": envs[:key]]

    "#{envs[:url]}/teams/league/#{api_football_league_id}"
    |> HTTPoison.get!(headers)
    |> (&(&1.body)).()
    |> Jason.decode!()
    |> (&(&1["api"]["teams"])).()
  end
end
