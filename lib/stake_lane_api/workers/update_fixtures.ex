defmodule StakeLaneApi.Workers.UpdateFixtures do
  @moduledoc false

  use Oban.Worker, queue: :events
  alias StakeLaneApi.Fixture
  alias StakeLaneApi.Prediction
  alias ApiFootball.ApiFixtures
  alias StakeLaneApi.Football.Fixture.Status

  @third_api "api_football"

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    done =
      @third_api
      |> Fixture.get_fixtures_to_update_results()
      |> Enum.map(fn fixture ->
        {:ok, _} =
          fixture.third_party_info["fixture_id"]
          |> ApiFixtures.get_fixture_by_id()
          |> ApiFixtures.parse_fixture_to_update()
          |> (&Fixture.update_fixture!(fixture, &1)).()
          |> maybe_update_predictions_score(fixture)
      end)

    {:ok, done}
  end

  defp maybe_update_predictions_score(updated_fixture, previous_fixture) do
    scoreboard_stays_the_same =
      previous_fixture.goals_home_team === updated_fixture.goals_home_team and
        previous_fixture.goals_away_team === updated_fixture.goals_away_team

    fixture_has_finished = updated_fixture.status_code in Status.finished_status_codes()

    updated_fixture
    |> update_predictions_score(scoreboard_stays_the_same, fixture_has_finished)
  end

  defp update_predictions_score(_, true, false), do: {:ok, :predictions_hasnt_changed}

  defp update_predictions_score(updated_fixture, _, _) do
    Prediction.update_predictions_score(updated_fixture)
  end
end
