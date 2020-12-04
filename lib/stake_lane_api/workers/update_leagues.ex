defmodule StakeLaneApi.Workers.UpdateLeagues do
  @moduledoc """
    Updates Leagues information,
    Starting date, ending date, if it is still active, etc.
  """

  use Oban.Worker, queue: :events
  alias StakeLaneApi.League
  alias ApiFootball.ApiLeagues

  @third_api "api_football"

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    done =
      @third_api
      |> League.list_active_leagues_by_third_api()
      |> Enum.map(fn league ->
        {:ok, _} =
          league.third_party_info["league_id"]
          |> ApiLeagues.get_league_by_id()
          |> ApiLeagues.parse_league_to_update()
          |> (&League.update_league(league, &1)).()
      end)

    {:ok, done}
  end
end
