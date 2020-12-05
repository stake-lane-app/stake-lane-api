defmodule StakeLaneApiWeb.V1.SessionController do
  use StakeLaneApiWeb, :controller

  alias StakeLaneApiWeb.APIAuthPlug
  alias Plug.Conn
  alias StakeLaneApi.User
  alias StakeLaneApi.RelevantAction
  alias StakeLaneApiWeb.Utils.IpLocation
  import StakeLaneApiWeb.Gettext

  defp parse_user(user) do
    [language | _other_languages] = user.languages

    %{
      user_name: user.user_name,
      email: user.email,
      role: user.role,
      language: language,
      id: user.id
    }
  end

  defp parse_params(conn, user_params) do
    email =
      case Map.fetch(user_params, "user_name") do
        {:ok, user_name} ->
          User.get_email_by_user_name(user_name)
          |> case do
            {:ok, email} ->
              email

            {:not_found, nil} ->
              conn
              |> put_status(401)
              |> json(%{
                error: %{status: 401, message: dgettext("errors", "Credentials Incorrect")}
              })
          end

        _ ->
          Map.get(user_params, "email")
      end

    %{
      "email" => email,
      "password" => Map.get(user_params, "password")
    }
  end

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => params}) do
    # Figure out how to set the user's language properly
    # Gettext.put_locale("es_LT")
    parsed_params = parse_params(conn, params)

    conn
    |> Pow.Plug.authenticate_user(parsed_params)
    |> case do
      {:ok, conn} ->
        user = conn |> Pow.Plug.current_user() |> parse_user
        user_ip = conn |> IpLocation.get_ip_from_header()
        user_agent = conn |> get_req_header("user-agent") |> to_string

        RelevantAction.relevant_actions()[:Login]
        |> RelevantAction.create(user.id, user_ip, user_agent)

        json(conn, %{
          data: %{
            access_token: conn.private[:api_access_token],
            renewal_token: conn.private[:api_renewal_token],
            user: user
          }
        })

      {:error, conn} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: dgettext("errors", "Credentials Incorrect")}})
    end
  end

  @spec renew(Conn.t(), map()) :: Conn.t()
  def renew(conn, _params) do
    config = Pow.Plug.fetch_config(conn)

    conn
    |> APIAuthPlug.renew(config)
    |> case do
      {conn, nil} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid token"}})

      {conn, raw_user} ->
        json(conn, %{
          data: %{
            access_token: conn.private[:api_access_token],
            renewal_token: conn.private[:api_renewal_token],
            user: raw_user |> parse_user
          }
        })
    end
  end

  @spec delete(Conn.t(), map()) :: Conn.t()
  def delete(conn, _params) do
    conn
    |> Pow.Plug.delete()
    |> json(%{data: %{}})
  end
end
