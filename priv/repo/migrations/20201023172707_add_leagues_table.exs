defmodule BolaoHubApi.Repo.Migrations.AddLeaguesTable do
  use Ecto.Migration

  def change do
    create table("leagues") do
      add :name,               :string, size: 30, null: false
      add :country,            :string, size: 15, null: false
      add :country_code,       :string, size: 5, null: false
      add :season,             :integer, comment: "When it get started", null: false
      add :season_start,       :date
      add :season_end,         :date
      add :active,             :boolean, default: true, null: false
      add :third_parties_info, :jsonb, default: "[]"

      timestamps()
    end

    create index("leagues", [:name, :country_code, :season])
  end
end
