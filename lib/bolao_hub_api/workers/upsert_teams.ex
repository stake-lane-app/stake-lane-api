defmodule BolaoHubApi.Workers.UpsertTeams do
  @moduledoc """
    Upsert Teams by third_parties_info[api].league_id,
  """
  
  use Oban.Worker, queue: :events
  alias BolaoHubApi.League
  alias BolaoHubApi.Leagues.ThirdPartyInfo, as: LeagueThird
  alias BolaoHubApi.Team
  alias BolaoHubApi.Country

  @third_api "api_football"

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    envs = Application.fetch_env!(:bolao_hub_api, :football_api)
    
    done = @third_api
    |> League.list_api_football_active_leagues
    |> Enum.map(&request_teams(&1, envs))
    |> Enum.map(&upsert_teams(&1))

    { :ok, done }
  end

  defp request_teams(league, envs) do
    %LeagueThird{ league_id: third_party_league_id } = league.third_parties_info
    |> Enum.find(&(&1.api == @third_api))

    headers = ["X-RapidAPI-Key": envs[:key]]

    "#{envs[:url]}/teams/league/#{third_party_league_id}"
    |> HTTPoison.get!(headers)
    |> (&(&1.body)).()
    |> Jason.decode!()
    |> (&(&1["api"]["teams"])).()
  end

  defp upsert_teams(refreshed_teams) do
    refreshed_teams
    |> Enum.map(fn refreshed_team -> 

      Team.get_team_by_third_id(@third_api, refreshed_team["team_id"])
      |> case  do
        nil -> create_team(refreshed_team)
        current_team -> update_team(current_team, refreshed_team)
      end

    end)
  end

  defp create_team(team) do
    new_team = %{
      name: team["name"],
      logo: team["logo"],
      is_national: team["is_national"],
      country_id: get_country_id(team["country"]),
      founded: team["founded"],
      venue: %{
        name: team["venue_name"],
        surface: team["venue_surface"],
        address: team["venue_address"],
        city: team["venue_city"],
        capacity: team["venue_capacity"],
      },
      third_parties_info: [
        %{
          api: @third_api,
          team_id: team["team_id"]
        }
      ]
    }

    new_team
    |> Team.create_team()
  end

  defp update_team(team, refreshed_team) do
    updated_team = %{
      logo: refreshed_team["logo"],
      founded: refreshed_team["founded"],
      country_id: get_country_id(refreshed_team["country"]),
      venue: %{
        name: refreshed_team["venue_name"],
        surface: refreshed_team["venue_surface"],
        address: refreshed_team["venue_address"],
        city: refreshed_team["venue_city"],
        capacity: refreshed_team["venue_capacity"],
      },
    }
    
    team
    |> Team.update_team(updated_team)
  end

  defp get_country_id(nil), do: nil
  defp get_country_id(country_name) do
    country_name
    |> Country.get_country_by_name
    |> case  do
      nil -> nil
      country -> Map.get(country, :id, nil)
    end
  end

end