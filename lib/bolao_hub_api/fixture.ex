defmodule BolaoHubApi.Fixture do
  @moduledoc """
  The Fixture context.
  """

  import Ecto.Query, warn: false
  alias BolaoHubApi.Repo

  alias BolaoHubApi.Fixtures.Fixture

  def get_fixture_by_third_id(third_api, third_fixture_id) do
    query = from t in Fixture,
      where: fragment(
        "third_parties_info @> ?",
        ^[%{"api" => third_api, "fixture_id" => third_fixture_id}]
      )

    query 
    |> Repo.one()
  end

  @doc """
  Updates a fixture.

  ## Examples

      iex> update_fixture(fixture, %{field: new_value})
      {:ok, %Fixture{}}

      iex> update_fixture(fixture, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fixture(%Fixture{} = fixture, attrs) do
    fixture
    |> Fixture.changeset(attrs)
    |> Repo.update()
  end

  def create_fixture(attrs \\ %{}) do
    %Fixture{}
    |> Fixture.changeset(attrs)
    |> Repo.insert()
  end
end
