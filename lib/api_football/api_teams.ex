defmodule ApiFootball.ApiTeams do
  @moduledoc false

  def get_team_by_league_id(api_football_league_id) do
    envs = Application.fetch_env!(:stake_lane_api, :football_api)
    headers = ["X-RapidAPI-Key": envs[:key]]

    "#{envs[:url]}/teams/league/#{api_football_league_id}"
    |> HTTPoison.get!(headers)
    |> (& &1.body).()
    |> Jason.decode!()
    |> (& &1["api"]["teams"]).()
  end

  def parse_team_to_creation(team, country_id) do
    team
    |> updatable_fields(country_id)
    |> Map.merge(%{
      name: team["name"],
      is_national: team["is_national"],
      third_parties_info: [
        %{
          api: "api_football",
          team_id: team["team_id"]
        }
      ]
    })
  end

  def parse_team_to_update(refreshed_team, country_id) do
    refreshed_team |> updatable_fields(country_id)
  end

  defp updatable_fields(team, country_id) do
    %{
      logo: team["logo"],
      founded: team["founded"],
      country_id: country_id,
      venue: team |> parse_venue
    }
  end

  defp parse_venue(team) do
    %{
      name: team["venue_name"],
      surface: team["venue_surface"],
      address: team["venue_address"],
      city: team["venue_city"],
      capacity: team["venue_capacity"]
    }
  end
end
