defmodule BolaoHubApi.Repo.Migrations.AddCountries do
  use Ecto.Migration

  def change do
    create table("countries") do
      add :name,               :string, size: 50, null: false
      add :code,               :string, size: 10, null: false
      add :flag,               :string, size: 100

      timestamps()
    end

  create index("countries", [:name])
  end
end
