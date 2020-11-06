defmodule BolaoHubApi.Workers.UpdateResults do
  @moduledoc false

  use Oban.Worker, queue: :events
  alias BolaoHubApi.Fixture
  alias ApiFootball.GetFixtures

  @third_api "api_football"

  @impl Oban.Worker
  def perform(%Oban.Job{}) do

    done = @third_api
      |> Fixture.get_fixtures_to_update_results
      |> Enum.map(fn fixture ->
        fixture.third_part_info["fixture_id"]
        |> GetFixtures.get_fixture_by_id
        |> GetFixtures.parse_fixture_to_update
        |> (&(Fixture.update_fixture(fixture, &1))).()
      end)

    {:ok, done}
  end
end
