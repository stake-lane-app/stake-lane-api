defmodule StakeLaneApi.Repo.Migrations.AddPlans do
  use Ecto.Migration

  def change do
    create table(:plans) do
      add :name, :string, null: false
      add :price, :money_with_currency, null: false
      add :valid, :boolean, default: true, null: false
      add :selectable, :boolean, default: true, null: false

      timestamps()
    end

    create unique_index(:plans, [:name, :price, :selectable])
  end
end
