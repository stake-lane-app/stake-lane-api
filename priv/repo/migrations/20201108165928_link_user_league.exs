defmodule BolaoHubApi.Repo.Migrations.LinkUserLeague do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:users_leagues) do
      add :league_id,   references("leagues", on_delete: :delete_all), null: false
      add :user_id,     references("users", on_delete: :delete_all), null: false
      add :blocked,     :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:users_leagues, [:league_id, :user_id])
  end
end
