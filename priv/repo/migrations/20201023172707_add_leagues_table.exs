defmodule StakeLaneApi.Repo.Migrations.AddLeaguesTable do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table("leagues") do
      add :name,               :string, size: 30, null: false
      add :country_id,         references("countries", on_delete: :delete_all)
      add :season,             :integer, comment: "When it get started", null: false
      add :season_start,       :date
      add :season_end,         :date
      add :active,             :boolean, default: true, null: false
      add :third_parties_info, :jsonb, default: "[]"

      timestamps()
    end

    create unique_index("leagues", [:name, :country_id, :season])
  end
end
