defmodule BolaoHubApi.Repo.Migrations.AddTeamsTable do
  use Ecto.Migration

  def change do
    create table("teams") do
      add :name,               :string, size: 30, null: false
      add :full_name,          :string, size: 100
      add :logo,               :string, size: 100
      add :is_national,        :boolean, default: false, null: false
      add :country,            :string, size: 100
      add :founded,            :integer
      add :venue,              :jsonb, default: "[]"

      timestamps()
    end

  create index("teams", [:name, :country])
  end
end
