defmodule StakeLaneApi.UserPlan do
  @moduledoc """
  The UserPlan context.
  """

  import Ecto.Query, warn: false
  alias StakeLaneApi.Repo
  alias StakeLaneApi.Finances.Plan
  alias StakeLaneApi.Links.UserPlan

  # TODO: get it dinamically
  def get_user_plan(_user_id, :team_leagues) do
    "number_one_fan" |> String.to_atom()
  end

  def get_user_plan(_user_id, _) do
    "free" |> String.to_atom()
  end

  def get_user_plan_limits(user_plan, league_type) do
    case Plan.Types.plans()[user_plan][league_type] do
      nil -> {:error, "Plan does not exist (#{user_plan}/#{league_type})"}
      plan_limits -> {:ok, plan_limits}
    end
  end

  def create_basic_plan(%Plan{} = plan, user_id) do
    no_expiraton = Timex.now("UTC") |> Timex.shift(years: +50)

    %UserPlan{}
    |> UserPlan.changeset(%{
      user_id: user_id,
      plan_id: plan.id,
      valid_until: no_expiraton
    })
    |> Repo.insert()
  end
end
