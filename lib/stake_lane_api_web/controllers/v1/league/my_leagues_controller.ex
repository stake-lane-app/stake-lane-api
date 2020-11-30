defmodule StakeLaneApiWeb.V1.League.MyLeaguesController do
  use StakeLaneApiWeb, :controller

  alias Ecto.Changeset
  alias StakeLaneApi.UserLeague
  alias StakeLaneApiWeb.ErrorHelpers

  def create(conn, params) do
    league_id = params |> Map.get("league_id")
    team_id = params |> Map.get("team_id")

    conn
    |> Pow.Plug.current_user
    |> Map.get(:id)
    |> (fn user_id -> UserLeague.create_user_league(user_id, league_id, team_id) end).()
    |> case do
      {:ok, _} ->
        conn |> send_resp(204, "")

      {:treated_error, treated_error} ->
        conn
        |> put_status(treated_error.status)
        |> json(%{treated_error: treated_error})

      {:error, changeset} ->
        errors = Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
        conn
        |> put_status(400)
        |> json(%{error: %{status: 400, message: dgettext("errors", "Couldn't link the league"), errors: errors}})

    end
  end

  def index(conn, _) do
    conn
    |> Pow.Plug.current_user
    |> Map.get(:id)
    |> (&(UserLeague.get_user_leagues/1)).()
    |> case do
      leagues ->
        conn
        |> put_status(200)
        |> json(leagues)
    end
  end

end
