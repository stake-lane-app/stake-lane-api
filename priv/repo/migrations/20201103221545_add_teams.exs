defmodule BolaoHubApi.Repo.Migrations.AddTeams do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table("teams") do
      add :name,               :string, size: 30, null: false
      add :full_name,          :string, size: 100
      add :logo,               :string, size: 100
      add :is_national,        :boolean, default: false, null: false
      add :country_id,         references("countries", on_delete: :delete_all)
      add :founded,            :integer
      add :venue,              :jsonb, default: "[]"
      add :third_parties_info, :jsonb, default: "[]"

      timestamps()
    end

    create unique_index("teams", [:name, :country_id])
  end
end
