defmodule StakeLaneApiWeb.V1.Prediction.PredictionsController do
  use StakeLaneApiWeb, :controller

  alias Ecto.Changeset
  alias StakeLaneApiWeb.ErrorHelpers
  alias StakeLaneApi.Prediction

  def create(conn, params) do
    %{
      "fixture_id" => fixture_id,
      "prediction_home_team" => prediction_home_team,
      "prediction_away_team" => prediction_away_team,
      } = params

    conn
    |> Pow.Plug.current_user
    |> Map.get(:id)
    |> (&(Prediction.create_prediction(&1, fixture_id, prediction_home_team, prediction_away_team))).()
    |> case  do
      {:ok, _} ->
        conn |> send_resp(204, "")
      {:error, changeset} ->
        errors = Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)

        conn
        |> put_status(400)
        |> json(%{error: %{status: 400, message: dgettext("errors", "Couldn't save the prediction"), errors: errors}})
    end
  end

end
