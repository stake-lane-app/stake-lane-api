defmodule StakeLaneApi.Repo.Migrations.AddPredictions do
  use Ecto.Migration

  def change do
    create table(:predictions) do
      add :user_id,     references("users", on_delete: :delete_all), null: false
      add :fixture_id,  references("fixture", on_delete: :delete_all), null: false
      add :home_team_prediction,   :integer, null: false
      add :away_team_prediction,   :integer, null: false

      timestamps()
    end

    create unique_index(:predictions, [:user_id, :fixture_id])
  end
end
