defmodule BolaoHubApiWeb.V1.SessionController do
  use BolaoHubApiWeb, :controller

  alias BolaoHubApiWeb.APIAuthPlug
  alias Plug.Conn

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
    |> Pow.Plug.authenticate_user(user_params)
    |> case do
      {:ok, conn} ->
        json(conn, %{data: %{access_token: conn.private[:api_access_token], renewal_token: conn.private[:api_renewal_token]}})

      {:error, conn} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid email or password"}})
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

      {conn, user} ->
        json(conn, %{
          data: %{
            access_token: conn.private[:api_access_token],
            renewal_token: conn.private[:api_renewal_token],
            user: userSchema(user),
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