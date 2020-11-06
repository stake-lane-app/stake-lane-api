defmodule ApiFootball.GetCountries do

  def get_countries() do
    envs = Application.fetch_env!(:bolao_hub_api, :football_api)
    headers = ["X-RapidAPI-Key": envs[:key]]

    "#{envs[:url]}/countries"
    |> HTTPoison.get!(headers)
    |> (&(&1.body)).()
    |> Jason.decode!()
    |> (&(&1["api"]["countries"])).()
  end

end
