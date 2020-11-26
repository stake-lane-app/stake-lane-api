defmodule StakeLaneApi.Team do
  @moduledoc """
  The Team context.
  """

  import Ecto.Query, warn: false
  alias StakeLaneApi.Repo
  alias StakeLaneApi.Football.Team

  def get_team_by_third_id(third_api, third_team_id) do
    query = from t in Team,
      where: fragment(
        "third_parties_info @> ?",
        ^[%{"api" => third_api, "team_id" => third_team_id}]
      )

    query
    |> Repo.one()
  end

  def list_team_by_country(country_id) do
    query = from team in Team,
    inner_join: country in assoc(team, :country),
    where: team.country_id == ^country_id,
    select: %{
      team |
      country: country
    }

    query
    |> Repo.all()
  end

  def is_national?(team_id) do
    query = from team in Team,
    where:
      team.id == ^team_id and
      team.is_national == ^true

    query
    |> Repo.exists?
  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %Team{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%Team{} = team, attrs) do
    team
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end
end
