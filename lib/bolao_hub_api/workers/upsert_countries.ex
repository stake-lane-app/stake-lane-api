defmodule BolaoHubApi.Workers.UpsertCountries do
  use Oban.Worker, queue: :events
  alias BolaoHubApi.Country

  @doc """
    Upsert Countries by third_parties_info[api].league_id,
  """
  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    envs = Application.fetch_env!(:bolao_hub_api, :football_api)
    
    envs
    |> request_countries()
    |> upsert_countries()

    :ok
  end

  defp request_countries(envs) do
    headers = ["X-RapidAPI-Key": envs[:key]]

    "#{envs[:url]}/countries"
    |> HTTPoison.get!(headers)
    |> (&(&1.body)).()
    |> Jason.decode!()
    |> (&(&1["api"]["countries"])).()
  end

  defp upsert_countries(refreshed_countries) do
    refreshed_countries
    |> Enum.map(fn refreshed_country -> 

      Country.get_country_by_name(refreshed_country["country"])
      |> case  do
        nil -> create_country(refreshed_country)
        current_country -> update_country(current_country, refreshed_country)
      end

    end)
  end

  defp create_country(country) do
    new_country = %{
      name: country["country"], 
      code: country["code"], 
      flag: country["flag"], 
    }

    new_country
    |> Country.create_country()
  end

  defp update_country(country, refreshed_country) do
    updated_country = %{
      logo: refreshed_country["logo"],
    }
    
    country
    |> Country.update_country(updated_country)
  end

end