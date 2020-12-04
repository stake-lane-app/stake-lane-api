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
         previous_prediction <- get_user_prediciton(fixture_id, user_id) do

      %{
        user_id: user_id,
        fixture_id: fixture_id,
        home_team: prediction_home_team,
        away_team: prediction_away_team,
      }
      |> upsert_prediction_(previous_prediction)
    end

  end

  defp get_user_prediciton(fixture_id, user_id) do
    query = from p in Prediction,
      where:
        p.fixture_id == ^fixture_id and
        p.user_id == ^user_id

    query
    |> Repo.one
  end

  defp verify_user_league(user_id, fixture_id) do
    user_plays_league = UserLeague.user_plays_league?(user_id, fixture_id)
    user_plays_team_league = UserLeague.user_plays_team_league?(user_id, fixture_id)

    case {user_plays_league, user_plays_team_league} do
      {false, false} -> dgettext("errors", "You don't play this league") |> Errors.treated_error
      user_plays_it -> {:ok, user_plays_it}
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

  def update_predictions_score(%StakeLaneApi.Football.Fixture{} = fixture) do
    %{
      id: fixture_id ,
      status_code: fixture_status_code,
      goals_home_team: goals_home_team,
      goals_away_team: goals_away_team
    } = fixture

    fixture_id
    |> get_fixture_predicitons
    |> Enum.map(&get_prediction_score(&1, fixture_status_code, goals_home_team, goals_away_team))
    |> Enum.map(&update_score!/1)
    |> (&{:ok, &1}).()
  end

  defp get_fixture_predicitons(fixture_id) do
    query = from p in Prediction,
      where:
        p.fixture_id == ^fixture_id

    query
    |> Repo.all
  end

  defp get_prediction_score(%Prediction{} = prediction, fixture_status_code, goals_home_team, goals_amay_team) do
    who_leads_fixture = get_who_leads(goals_home_team, goals_amay_team)
    who_leads_prediction = get_who_leads(prediction.home_team, prediction.away_team)

    score = calculate_prediction(
      who_leads_fixture === who_leads_prediction,
      prediction.home_team === goals_home_team,
      prediction.away_team === goals_amay_team,
      [goals_home_team, goals_amay_team, prediction.home_team, prediction.away_team]
    )

    %{
      prediction: prediction,
      updated_attrs: %{
        score: score,
        finished: fixture_status_code in Status.finished_status_codes,
      }
    }
  end

  defp get_who_leads(nil, nil), do: nil
  defp get_who_leads(home_team, away_team) when home_team > away_team,   do: :home_team
  defp get_who_leads(home_team, away_team) when home_team < away_team,   do: :away_team
  defp get_who_leads(home_team, away_team) when home_team === away_team, do: :draw
  defp get_who_leads(_, _), do: :unknown

  @bingo 20
  @who_leads_max 16
  @who_leads_min 5
  @zero 0
  defp calculate_prediction(true, true, true, _), do: @bingo
  defp calculate_prediction(true, _, _, goals) do
    [
      goals_home_team,
      goals_amay_team,
      prediction_home_team,
      prediction_away_team,
    ] = goals

    home_team_diff = goals_home_team - prediction_home_team |> Kernel.abs
    away_team_diff = goals_amay_team - prediction_away_team |> Kernel.abs

    @who_leads_max - home_team_diff - away_team_diff
    |> case do
      who_leads_score when (who_leads_score < @who_leads_min) -> @who_leads_min
      who_leads_score -> who_leads_score
    end
  end
  defp calculate_prediction(_, _, _, _), do: @zero

  defp update_score!(prediction) do
    prediction[:prediction]
    |> Prediction.changeset(prediction[:updated_attrs])
    |> Repo.update!()
  end

end
