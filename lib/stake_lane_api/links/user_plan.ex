defmodule StakeLaneApi.Links.UserPlan do
  use Ecto.Schema
  import Ecto.Changeset
  alias StakeLaneApi.Users.User
  alias StakeLaneApi.Finances.Plan

  schema "users_plans" do
    belongs_to :user, User
    belongs_to :plan, Plan

    field :active, :boolean

    timestamps()
  end

  def changeset(changeset, attrs) do
    changeset
    |> cast(attrs, [
      :user_id,
      :plan_id,
      :active
    ])
    |> validate_required([
      :user_id,
      :plan_id,
      :active
    ])
    |> unique_constraint([:user_id, :plan_id])
  end
end
