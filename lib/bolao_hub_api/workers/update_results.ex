defmodule BolaoHubApi.Workers.UpdateResults do
  @moduledoc false

  use Oban.Worker, queue: :events
  alias BolaoHubApi.Fixture

  @impl Oban.Worker
  def perform(%Oban.Job{}) do

    envs = Application.fetch_env!(:bolao_hub_api, :football_api)

    done = @third_api
      |> Fixture.get_fixtures_to_update_results

    :ok
  end

end