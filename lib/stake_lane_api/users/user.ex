defmodule StakeLaneApi.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  use PowAssent.Ecto.Schema
  import Ecto.Changeset
  alias StakeLaneApi.Users.{Prediction, RelevantAction}

  schema "users" do
    field :user_name, :string
    field :role, :string
    field :languages, {:array, :string}

    field :email_confirmed, :boolean
    field :first_name, :string
    field :last_name, :string
    field :social_email, :string
    field :cellphone_number, :string
    field :picture, :string
    field :locked, :boolean
    field :bio, :string

    pow_user_fields()
    timestamps()

    has_many :relevant_action, RelevantAction
    has_many :prediction, Prediction
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> unique_constraint(:user_name)
    |> cast(attrs, [:user_name])
    |> validate_required([:user_name])
    |> validate_length(:user_name, max: 20)
    |> validate_subset(:role, ["user", "admin"])
  end
end
