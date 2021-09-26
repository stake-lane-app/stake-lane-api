defmodule StakeLaneApi.Repo.Migrations.AddPools do
  use Ecto.Migration

  def change do
    create table(:pools) do
      add :name, :string, null: false

      add :league_id, references("leagues", on_delete: :delete_all)
      add :team_id, references("teams", on_delete: :delete_all)

      timestamps()
    end
  end
end
