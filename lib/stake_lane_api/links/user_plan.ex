defmodule StakeLaneApi.Links.UserPlan do
  use Ecto.Schema
  import Ecto.Changeset
  alias StakeLaneApi.Users.User
  alias StakeLaneApi.Finances.Plan

  schema "user_plans" do
    belongs_to :user, User
    belongs_to :plan, Plan

    field :active, :boolean
    field :valid_until, :utc_datetime

    timestamps()
  end

  def changeset(changeset, attrs) do
    changeset
    |> cast(attrs, [
      :user_id,
      :type,
      :active,
      :valid_until
    ])
    |> validate_required([
      :user_id,
      :type,
      :active,
      :valid_until
    ])
    |> unique_constraint(:user_id)
  end
end
