defmodule BolaoHubApi.League do
  @moduledoc """
  The League context.
  """

  import Ecto.Query, warn: false
  alias BolaoHubApi.Repo

  alias BolaoHubApi.Leagues.League

  def list_api_football_active_leagues() do
    query = from l in League,
      where: l.active == true and
      fragment("third_parties_info @> '[{\"api\": \"api_football\" }]'")
    
    query 
    |> Repo.all()
  end

  @doc """
  Updates a league.

  ## Examples

      iex> update_league(league, %{field: new_value})
      {:ok, %Project{}}

      iex> update_league(league, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_league(%League{} = league, attrs) do
    league
    |> League.changeset(attrs)
    |> Repo.update()
  end

end
