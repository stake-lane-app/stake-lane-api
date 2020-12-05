defmodule StakeLaneApi.Country do
  @moduledoc """
  The Country context.
  """

  import Ecto.Query, warn: false
  alias StakeLaneApi.Repo

  alias StakeLaneApi.Countries.Country

  def get_country_by_name(name) do
    query =
      from c in Country,
        where: c.name == ^name

    query
    |> Repo.one()
  end

  def list_countries() do
    query = from(c in Country)

    query
    |> Repo.all()
  end

  def update_country(%Country{} = country, attrs) do
    country
    |> Country.changeset(attrs)
    |> Repo.update()
  end

  def create_country(attrs \\ %{}) do
    %Country{}
    |> Country.changeset(attrs)
    |> Repo.insert()
  end
end
