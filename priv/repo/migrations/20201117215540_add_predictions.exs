defmodule StakeLaneApi.Repo.Migrations.AddPredictions do
  use Ecto.Migration

  def change do
    create table(:predictions) do
      add :user_id,     references("users", on_delete: :delete_all), null: false
      add :fixture_id,  references("fixtures", on_delete: :delete_all), null: false
      add :home_team,   :integer, null: false
      add :away_team,   :integer, null: false
      add :score,       :integer
      add :finished,    :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:predictions, [:user_id, :fixture_id])
  end
end
