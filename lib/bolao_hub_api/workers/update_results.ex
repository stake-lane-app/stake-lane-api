defmodule BolaoHubApi.Workers.UpdateResults do
  @moduledoc false

  use Oban.Worker, queue: :events
  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    :ok
  end

end