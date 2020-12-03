defmodule StakeLaneApi.UserPlan do
  @moduledoc """
  The UserPlan context.
  """

  import Ecto.Query, warn: false

  def get_user_plan(_user_id) do
    "free" |> String.to_atom
  end

  def get_user_plan_limits(user_plan) do
    envs = Application.fetch_env!(:stake_lane_api, :limits)
    case envs[user_plan].leagues do
      nil -> {:error, "Plan does not exist (#{user_plan})"}
      plan_limits -> {:ok, plan_limits}
    end
  end

end
