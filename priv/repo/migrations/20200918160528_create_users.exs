defmodule BolaoHubApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :password_hash, :string
      add :email, :string

      add :user_name, :string, size: 15, null: false
      add :email_confirmed, :boolean, default: false, null: false
      add :first_name, :string
      add :last_name, :string
      add :apple_id, :string
      add :google_id, :string
      add :facebook_id, :string
      add :social_email, :string
      add :cellphone_number, :string
      add :picture, :string
      add :locked, :boolean, default: false, null: false
      add :bio, :string
      add :role, :string, null: false, default: "user"
      add :languages, {:array, :string}, default: ["EN"], null: false

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:user_name])
    create unique_index(:users, [:apple_id])
    create unique_index(:users, [:google_id])
    create unique_index(:users, [:facebook_id])
  end
end
