defmodule ApiFootball.GetLeagues do

  def get_league_by_league_id(api_football_league_id) do
    envs = Application.fetch_env!(:bolao_hub_api, :football_api)
    headers = ["X-RapidAPI-Key": envs[:key]]

    "#{envs[:url]}/leagues/league/#{api_football_league_id}"
      |> HTTPoison.get!(headers)
      |> (&(&1.body)).()
      |> Jason.decode!()
      |> (&(&1["api"]["leagues"])).()
      |> Enum.find(&(&1["league_id"] == api_football_league_id))
  end

end
