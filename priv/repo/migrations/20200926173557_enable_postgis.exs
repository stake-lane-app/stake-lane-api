defmodule BolaoHubApi.Repo.Migrations.EnablePostgis do
  @moduledoc false
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"
  end

  def down do
    execute "DROP EXTENSION IF EXISTS postgis"
  end
end
