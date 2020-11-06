defmodule BolaoHubApi.Workers.UpdateLeagues do
  @moduledoc """
    Updates Leagues information,
    Starting date, ending date, if it is still active, etc.
  """

  use Oban.Worker, queue: :events
  alias BolaoHubApi.League
  alias ApiFootball.GetLeagues

  @third_api "api_football"

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    done = @third_api
    |> League.list_active_leagues_by_third_api
    |> Enum.map(&request_league(&1))
    |> Enum.map(&update_league(&1))

    { :ok, done }
  end

  defp request_league(league) do
    %{
      "actual_league" => league,
      "refreshed_league" => league.third_party_info["league_id"] |> GetLeagues.get_league_by_league_id(),
    }
  end

  defp update_league(league) do
    refreshed_season_start = Date.from_iso8601!(league["refreshed_league"]["season_start"])
    refreshed_season_end = Date.from_iso8601!(league["refreshed_league"]["season_end"])

    is_active = Date.utc_today()
      |> Date.diff(refreshed_season_end)
      |> is_league_active()

    refreshed_attrs = %{
      is_active: is_active,
      season_start: refreshed_season_start,
      season_end: refreshed_season_end,
    }

    { :ok, _ } = League.update_league(league["actual_league"], refreshed_attrs)
  end

  defp is_league_active(diff_date) when diff_date <= 0, do: true
  defp is_league_active(_), do: false
end
