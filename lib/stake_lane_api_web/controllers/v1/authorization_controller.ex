defmodule StakeLaneApiWeb.V1.AuthorizationController do
  use StakeLaneApiWeb, :controller

  alias Plug.Conn
  alias PowAssent.Plug
  alias StakeLaneApi.RelevantAction
  alias StakeLaneApiWeb.Utils.IpLocation

  @spec new(Conn.t(), map()) :: Conn.t()
  def new(conn, %{"provider" => provider}) do
    conn
    |> Plug.authorize_url(provider, redirect_uri(conn))
    |> case do
      {:ok, url, conn} ->
        json(conn, %{data: %{url: url, session_params: conn.private[:pow_assent_session_params]}})

      {:error, _error, conn} ->
        conn
        |> put_status(500)
        |> json(%{error: %{status: 500, message: "An unexpected error occurred"}})
    end
  end

  defp redirect_uri(conn) do
    api_url = System.get_env("API_URL")
    "#{api_url}/api/v1/auth/#{conn.params["provider"]}/callback"
  end

  @spec callback(Conn.t(), map()) :: Conn.t()
  def callback(conn, %{"provider" => provider} = params) do
    session_params = Map.fetch!(params, "session_params")
    params = Map.drop(params, ["provider", "session_params"])

    # TODO: How to create the user's username?
    # TODO: Is is possible to get the user's language case yes, let's do it
    # TODO: What about user's profile picture?

    conn
    |> Conn.put_private(:pow_assent_session_params, session_params)
    |> Plug.callback_upsert(provider, params, redirect_uri(conn))
    |> case do
      {:ok, conn} ->
        user = conn |> Pow.Plug.current_user()

        # TODO: create user plan, default: free

        user_ip = conn |> IpLocation.get_ip_from_header()
        user_agent = conn |> get_req_header("user-agent") |> to_string

        RelevantAction.relevant_actions()[:registered]
        |> RelevantAction.create(user.id, user_ip, user_agent)

        json(conn, %{
          data: %{
            token: conn.private[:api_auth_token],
            renew_token: conn.private[:api_renew_token]
          }
        })

      {:error, conn} ->
        conn
        |> put_status(500)
        |> json(%{error: %{status: 500, message: "An unexpected error occurred"}})
    end
  end
end
