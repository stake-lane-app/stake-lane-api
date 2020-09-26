defmodule BolaoHubApi.Repo.Migrations.CreateRelevantActions do
  use Ecto.Migration

  def change do
    create table(:relevant_actions) do
      add :action, :string, null: false
      add :ip_info, :map
      add :ip_coordinates, :geometry
      add :user_id, references("users")

      timestamps()
    end
  end
end
