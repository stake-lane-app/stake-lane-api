defmodule BolaoHubApi.Workers.UpsertTeams do
  use Oban.Worker, queue: :events
  #alias BolaoHubApi.League

  @doc """
    Updates Leagues information,
    Like starting date or ending date, or if it is still active
  """
  @impl Oban.Worker
  def perform(%Oban.Job{}) do

      
    :ok
  end

  # defp request_leagues(league, envs) do
  # end
end