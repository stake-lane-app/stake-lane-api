defmodule StakeLaneApiWeb.V1.Pool.PoolsController do
  use StakeLaneApiWeb, :controller

  alias StakeLaneApi.Pool

  def create(conn, params) do
    %{
      "participant_ids" => participant_ids,
      "name" => name
    } = params

    league_id = params |> Map.get("league_id")
    team_id = params |> Map.get("team_id")

    conn
    |> Pow.Plug.current_user()
    |> Map.get(:id)
    |> Pool.create_pool(league_id, team_id, participant_ids, name)
    |> IO.inspect(label: "gggg")
    |> case do
      {:ok, pool} ->
        conn
        |> put_status(201)
        |> json(pool)

      {:treated_error, treated_error} ->
        conn
        |> put_status(treated_error.status)
        |> json(%{treated_error: treated_error})

      {:error, error} ->
        conn
        |> put_status(400)
        |> json(%{
          error: %{
            status: 400,
            message: dgettext("errors", "Couldn't create the pool"),
            errors: error
          }
        })
    end
  end
end
