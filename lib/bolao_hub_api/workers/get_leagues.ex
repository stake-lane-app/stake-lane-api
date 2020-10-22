defmodule BolaoHubApi.Workers.GetLeagues do
  use Oban.Worker, queue: :events

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    alpha = "Here the app will request the leagues from the 3rd-party-api"
    IO.inspect alpha
    :ok
  end
end