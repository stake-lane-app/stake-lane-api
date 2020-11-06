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
    |> Enum.map(fn league ->
      league.third_party_info["league_id"]
      |> GetLeagues.get_league_id
      |> GetLeagues.parse_league_to_update
      |> (&(League.update_league(league, &1))).()
    end)

    { :ok, done }
  end
end
