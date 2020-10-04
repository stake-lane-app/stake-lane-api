defmodule BolaoHubApiWeb.V1.RegistrationController do
  use BolaoHubApiWeb, :controller

  alias Ecto.Changeset
  alias Plug.Conn
  alias BolaoHubApi.RelevantAction
  alias BolaoHubApiWeb.ErrorHelpers


  defp userSchema(user) do
    [language | _other_languages ] = user.languages

    %{
      user_name: user.user_name,
      email: user.email,
      role: user.role,
      language: language,
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

        RelevantAction.relevant_actions[:Registered]
          |> RelevantAction.create(user.id, user_ip, user_agent)

        json(conn, %{
          data: %{
            access_token: conn.private[:api_access_token],
            renewal_token: conn.private[:api_renewal_token],
            user: userSchema(user)
          }
        })

      {:error, changeset, conn} ->
        errors = Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)

        conn
        |> put_status(400)
        |> json(%{error: %{status: 400, message: "Couldn't create user", errors: errors}})
    end
  end
end