defmodule StakeLaneApi.Prediction do
  @moduledoc """
  The Prediction context.
  """

  import Ecto.Query, warn: false
  alias StakeLaneApi.Repo
  alias StakeLaneApi.Users.Prediction
  # alias StakeLaneApi.UserLeague

  def create_prediction(user_id, fixture_id, prediction_home_team, prediction_away_team) do
    attrs = %{
      user_id: user_id,
      fixture_id: fixture_id,
      home_team: prediction_home_team,
      away_team: prediction_away_team,
    }

    # TO DO: Validate if user has the user_league relation created and not-blocked
    # UserLeague.link_is_active(user_id, fixture_id)

    # TO DO: Validate the match has not gotten started

    IO.inspect(attrs)

    %Prediction{}
    |> Prediction.changeset(attrs)
    |> Repo.insert()
  end
end
