defmodule StakeLaneApi.Workers.UpdateFixtures do
  @moduledoc false

  use Oban.Worker, queue: :events
  alias StakeLaneApi.Fixture
  alias StakeLaneApi.Prediction
  alias ApiFootball.ApiFixtures

  @third_api "api_football"

  @impl Oban.Worker
  def perform(%Oban.Job{}) do

    done = @third_api
      |> Fixture.get_fixtures_to_update_results
      |> Enum.map(fn fixture ->
        {:ok, _} = fixture.third_party_info["fixture_id"]
        |> ApiFixtures.get_fixture_by_id
        |> ApiFixtures.parse_fixture_to_update
        |> (&Fixture.update_fixture!(fixture, &1)).()
        |> Prediction.update_prediction_score
      end)

    {:ok, done}
  end
end
