defmodule BolaoHubApi.Repo.Migrations.AddFixtures do
  use Ecto.Migration

  def change do
    create table("fixtures") do
      add :league_id,          references("leagues", on_delete: :delete_all), null: false
      add :home_team_id,       references("teams", on_delete: :delete_all), null: false
      add :away_team_id,       references("teams", on_delete: :delete_all), null: false
      add :score,              :jsonb, default: "[]"
      add :third_parties_info, :jsonb, default: "[]"


      add :goals_home_team,     :integer
      add :goals_away_team,     :integer

      add :starts_at_iso_date,          :datetime, null: false
      add :event_timestamp,     :integer, null: false

      add :status_short,        :string, default: "NS", null: false
      add :elapsed,             :integer
      add :venue,               :string
      add :referee,             :string

      timestamps()
    end


git s  end
end
