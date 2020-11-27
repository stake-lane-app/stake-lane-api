defmodule StakeLaneApiWeb.V1.Team.TeamsController do
  use StakeLaneApiWeb, :controller

  alias Ecto.Changeset
  alias StakeLaneApiWeb.ErrorHelpers
  alias StakeLaneApi.Team
  alias StakeLaneApi.UserTeam

  def index(conn, %{ "country_id" => country_id }) do
    country_id
    |> Team.list_team_by_country
    |> case do
      teams ->
        conn
        |> put_status(200)
        |> json(teams)
    end
  end

  def create(conn, params) do
    %{
      "level" => level,
      "team_id" => team_id,
    } = params

    conn
    |> Pow.Plug.current_user
    |> Map.get(:id)
    |> (&(UserTeam.upsert_user_team(&1, team_id, level))).()
    |> case do
      {:ok, _} ->
        conn
        |> send_resp(204, "")

      {:treated_error, treated_error} ->
        conn
        |> put_status(treated_error.status)
        |> json(%{treated_error: treated_error})

      {:error, changeset} ->
        errors = Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
        conn
        |> put_status(400)
        |> json(%{error: %{status: 400, message: dgettext("errors", "Couldn't save team preference"), errors: errors}})
    end
  end

  def delete(conn, params) do
    %{
      "level" => level,
    } = params

    conn
    |> Pow.Plug.current_user
    |> Map.get(:id)
    |> (&(UserTeam.delete_user_team_by_level(&1, level))).()
    |> case do
      {:ok, _} ->
        conn
        |> send_resp(204, "")

      {:treated_error, treated_error} ->
        conn
        |> put_status(treated_error.status)
        |> json(%{treated_error: treated_error})

      {:error, changeset} ->
        errors = Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
        conn
        |> put_status(400)
        |> json(%{error: %{status: 400, message: dgettext("errors", "Couldn't delete team preference"), errors: errors}})
    end
  end

end
