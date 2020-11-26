defmodule StakeLaneApi.Prediction do
  @moduledoc """
  The Prediction context.
  """

  import Ecto.Query, warn: false
  import StakeLaneApiWeb.Gettext
  alias StakeLaneApi.Repo
  alias StakeLaneApi.Users.Prediction
  alias StakeLaneApi.Fixture
  alias StakeLaneApi.UserLeague
  alias StakeLaneApi.Football.Fixture.Status
  alias StakeLaneApi.Helpers.Errors

  def upsert_prediction(user_id, fixture_id, prediction_home_team, prediction_away_team) do
    with {:ok, fixture} <- find_fixture(fixture_id),
         {:ok, _} <- verify_user_league(user_id, fixture_id),
         {:ok, _} <- fixture_allow_prediction(fixture),
         previous_prediction <- get_by_fixture_id(fixture_id) do

      %{
        user_id: user_id,
        fixture_id: fixture_id,
        home_team: prediction_home_team,
        away_team: prediction_away_team,
      }
      |> upsert_prediction_(previous_prediction)
    end

  end

  def get_by_fixture_id(fixture_id) do
    query = from p in Prediction,
      where: p.fixture_id == ^fixture_id

    query
    |> Repo.one
  end

  defp verify_user_league(user_id, fixture_id) do
    UserLeague.user_plays_league?(user_id, fixture_id)
    |> case do
      nil -> dgettext("errors", "You don't play this league") |> Errors.treated_error
      league -> {:ok, league}
    end
  end

  defp find_fixture(fixture_id) do
    fixture_id
    |> Fixture.get_fixture_by_id
    |> case do
      nil ->  dgettext("errors", "Fixture not found") |> Errors.treated_error(:not_found)
      fixture -> {:ok, fixture}
    end
  end

  defp fixture_allow_prediction(fixture) do
    fixture
    |> (&(&1.status_code in Status.allow_prediction)).()
    |> case do
      false -> dgettext("errors", "The fixture status does not allow prediction") |> Errors.treated_error
      allow_prediction -> {:ok, allow_prediction}
    end
  end

  defp upsert_prediction_(attrs, nil) do
    %Prediction{}
    |> Prediction.changeset(attrs)
    |> Repo.insert()
  end
  defp upsert_prediction_(attrs, %Prediction{} = previous_prediction) do
    previous_prediction
    |> Prediction.changeset(attrs)
    |> Repo.update()
  end

end
