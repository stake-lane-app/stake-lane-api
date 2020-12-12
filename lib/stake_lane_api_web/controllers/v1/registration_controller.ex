defmodule StakeLaneApiWeb.V1.RegistrationController do
  use StakeLaneApiWeb, :controller

  alias Ecto.Changeset
  alias Plug.Conn
  alias StakeLaneApi.RelevantAction
  alias StakeLaneApi.UserPlan
  alias StakeLaneApi.Plan
  alias StakeLaneApiWeb.ErrorHelpers
  alias StakeLaneApiWeb.Utils.IpLocation

  defp user_schema(user) do
    [language | _other_languages] = user.languages

    %{
      user_name: user.user_name,
      email: user.email,
      role: user.role,
      language: language
    }
  end

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    conn
    |> Pow.Plug.create_user(user_params)
    |> case do
      {:ok, user, conn} ->
        user_ip = conn |> IpLocation.get_ip_from_header()
        user_agent = conn |> get_req_header("user-agent") |> to_string

        Plan.get_plan(:free)
        |> UserPlan.create_basic_plan(user.id)

        RelevantAction.relevant_actions()[:registered]
        |> RelevantAction.create(user.id, user_ip, user_agent)

        json(conn, %{
          data: %{
            access_token: conn.private[:api_access_token],
            renewal_token: conn.private[:api_renewal_token],
            user: user_schema(user)
          }
        })

      {:error, changeset, conn} ->
        errors = Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)

        conn
        |> put_status(400)
        |> json(%{
          error: %{
            status: 400,
            message: dgettext("errors", "Couldn't create the user"),
            errors: errors
          }
        })
    end
  end
end
