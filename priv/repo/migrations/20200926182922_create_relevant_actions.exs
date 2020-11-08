defmodule BolaoHubApi.Repo.Migrations.CreateRelevantActions do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:relevant_actions) do
      add :action, :string, null: false
      add :user_agent, :string
      add :ip_info, :map
      add :ip_coordinates, :geometry
      add :user_id, references("users")

      timestamps()
    end
  end
end
