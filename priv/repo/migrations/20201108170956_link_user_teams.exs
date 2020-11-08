defmodule BolaoHubApi.Repo.Migrations.LinkUserTeams do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:users_teams) do
      add :team_id,     references("teams", on_delete: :delete_all), null: false
      add :user_id,     references("users", on_delete: :delete_all), null: false
      add :level,      :string, null: false

      timestamps()
    end

    create unique_index(:users_teams, [:team_id, :user_id])
  end
end
