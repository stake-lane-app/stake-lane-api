defmodule StakeLaneApi.Repo.Migrations.LinkUserTeamLeague do
  use Ecto.Migration

  def change do
    create table(:users_teams_leagues) do
      add :team_id,     references("teams", on_delete: :delete_all), null: false
      add :user_id,     references("users", on_delete: :delete_all), null: false
      add :blocked,     :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:users_teams_leagues, [:team_id, :user_id])
  end
end
