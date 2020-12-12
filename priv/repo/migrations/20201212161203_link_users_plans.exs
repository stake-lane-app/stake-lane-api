defmodule StakeLaneApi.Repo.Migrations.LinkUsersPlans do
  use Ecto.Migration

  def change do
    create table(:users_plans) do
      add :user_id, references("users", on_delete: :delete_all), null: false
      add :plan_id, references("plans", on_delete: :delete_all), null: false
      add :active, :boolean, default: true, null: false
      add :valid_until, :utc_datetime, null: false

      timestamps()
    end

    create unique_index(:users_plans, [:user_id, :plan_id])
  end
end
