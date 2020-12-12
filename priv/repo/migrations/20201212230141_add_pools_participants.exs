defmodule StakeLaneApi.Repo.Migrations.AddPoolsParticipants do
  use Ecto.Migration

  def change do
    create table(:pools_participants) do
      add :pool_id, references("pools", on_delete: :delete_all)
      add :user_id, references("users", on_delete: :delete_all)
      add :blocked, :boolean, default: false, null: false
    end

    create unique_index(:pools_participants, [:pool_id, :user_id])
  end
end
