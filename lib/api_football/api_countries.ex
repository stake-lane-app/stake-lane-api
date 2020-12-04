defmodule ApiFootball.ApiCountries do
  @moduledoc false

  def get_countries() do
    envs = Application.fetch_env!(:stake_lane_api, :football_api)
    headers = ["X-RapidAPI-Key": envs[:key]]

    "#{envs[:url]}/countries"
    |> HTTPoison.get!(headers)
    |> (& &1.body).()
    |> Jason.decode!()
    |> (& &1["api"]["countries"]).()
  end

  def parse_country_to_creation(country) do
    country
    |> updatable_fields
    |> Map.merge(%{
      name: country["country"],
      code: country["code"]
    })
  end

  def parse_country_to_update(refreshed_country) do
    refreshed_country |> updatable_fields
  end

  defp updatable_fields(country) do
    %{
      flag: country["flag"]
    }
  end
end
