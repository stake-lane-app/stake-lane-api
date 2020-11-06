defmodule BolaoHubApi.Workers.UpsertTeams do
  @moduledoc """
    Upsert Teams by third_parties_info[api].league_id,
  """

  use Oban.Worker, queue: :events
  alias BolaoHubApi.League
  alias BolaoHubApi.Team
  alias BolaoHubApi.Country
  alias ApiFootball.GetTeams

  @third_api "api_football"

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    done = @third_api
    |> League.list_active_leagues_by_third_api
    |> Enum.map(&request_teams(&1))
    |> Enum.map(&upsert_teams(&1))

    { :ok, done }
  end

  defp request_teams(league) do
    league.third_party_info["league_id"]
    |> GetTeams.get_team_by_league_id()
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
      founded: team["founded"],
      country_id: team["country"] |> get_country_id(),
      venue: team |> parse_venue(),
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
      country_id: refreshed_team["country"] |> get_country_id(),
      venue: refreshed_team |> parse_venue(),
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

  defp parse_venue(team) do
    %{
      name: team["venue_name"],
      surface: team["venue_surface"],
      address: team["venue_address"],
      city: team["venue_city"],
      capacity: team["venue_capacity"],
    }
  end
end
