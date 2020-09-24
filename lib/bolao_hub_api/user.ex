defmodule BolaoHubApi.User do
  @moduledoc """
  The User context.
  """

  import Ecto.Query, warn: false
  alias BolaoHubApi.Repo

  alias BolaoHubApi.Users.User

  @spec get_email_by_user_name(any) :: {:not_found, nil} | {:ok, charlist}
  def get_email_by_user_name(user_name) do
    query = from u in User,
      where: u.user_name == ^user_name,
      select: u.email

    with email when not is_nil(email) <- Repo.one query
    do
      {:ok, email}
    else
      _ -> {:not_found, nil}
    end
  end
end
