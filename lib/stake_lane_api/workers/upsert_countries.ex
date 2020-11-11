defmodule StakeLaneApi.Workers.UpsertCountries do
  @moduledoc """
    Upsert Countries by third_parties_info[api].league_id,
  """

  use Oban.Worker, queue: :events
  alias StakeLaneApi.Country
  alias ApiFootball.ApiCountries

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    ApiCountries.get_countries()
    |> upsert_countries()

    :ok
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
    new_country = country |> ApiCountries.parse_country_to_creation
    {:ok, _} = new_country |> Country.create_country()
  end

  defp update_country(country, refreshed_country) do
    updated_country = refreshed_country |> ApiCountries.parse_country_to_update
    {:ok, _} = country |> Country.update_country(updated_country)
  end

end
