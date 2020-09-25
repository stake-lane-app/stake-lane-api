defmodule BolaoHubApi.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :user_name, :string
    # field :email_confirmed, :boolean
    # field :first_name, :string
    # field :last_name, :string
    # field :apple_id, :string
    # field :google_id, :string
    # field :facebook_id, :string
    # field :social_email, :string
    # field :cellphone_number, :string
    # field :picture, :string
    # field :locked, :boolean
    # field :bio, :string
    field :role, :string
    field :languages, {:array, :string}
    
    pow_user_fields()

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> unique_constraint(:user_name)
    |> cast(attrs, [:user_name])
    |> validate_required([:user_name])
    |> validate_subset(:role, ["user", "admin"])
  end

end
