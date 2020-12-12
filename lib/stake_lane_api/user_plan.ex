defmodule StakeLaneApi.UserPlan do
  @moduledoc """
  The UserPlan context.
  """

  import Ecto.Query, warn: false
  alias StakeLaneApi.Repo
  alias StakeLaneApi.Finances.Plan
  alias StakeLaneApi.Links.UserPlan

  def get_user_plan(user_id) do
    query =
      from up in UserPlan,
        inner_join: plan in assoc(up, :plan),
        where: up.user_id == ^user_id,
        select: plan.name

    query
    |> Repo.one()
    |> case do
      nil ->
        create_basic_plan!(user_id)
        :free

      user_plan ->
        user_plan
    end
  end

  def get_user_plan_limits(user_plan, league_type) do
    case Plan.Types.plans()[user_plan][league_type] do
      nil -> {:error, "Plan does not exist (#{user_plan}/#{league_type})"}
      plan_limits -> {:ok, plan_limits}
    end
  end

  def create_basic_plan!(user_id) do
    no_expiraton = Timex.now("UTC") |> Timex.shift(years: +50)
    basic_plan = StakeLaneApi.Plan.get_plan(:free)

    %UserPlan{}
    |> UserPlan.changeset(%{
      user_id: user_id,
      plan_id: basic_plan.id,
      valid_until: no_expiraton,
      active: true
    })
    |> Repo.insert!()
  end
end
