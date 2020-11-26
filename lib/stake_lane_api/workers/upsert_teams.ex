defmodule StakeLaneApi.Workers.UpsertTeams do
  @moduledoc """
    Upsert Teams by third_parties_info[api].league_id,
  """

  use Oban.Worker, queue: :events
  alias StakeLaneApi.League
  alias StakeLaneApi.Team
  alias StakeLaneApi.Country
  alias ApiFootball.ApiTeams

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
    |> ApiTeams.get_team_by_league_id()
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
    country_id = team["country"] |> get_country_id
    {:ok, _} = team
    |> ApiTeams.parse_team_to_creation(country_id)
    |> Team.create_team()
  end

  defp update_team(team, refreshed_team) do
    country_id = refreshed_team["country"] |> get_country_id
    updated_team = refreshed_team |> ApiTeams.parse_team_to_update(country_id)
    {:ok, _} = team |> Team.update_team(updated_team)
  end

  defp get_country_id(nil), do: nil
  defp get_country_id(country_name) do
    country_name
    |> Country.get_country_by_name
    |> case  do
      nil -> nil
      country -> country |> Map.get(:id, nil)
    end
  end
end
