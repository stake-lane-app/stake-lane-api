defmodule StakeLaneApi.UserPlan do
  @moduledoc """
  The UserPlan context.
  """

  import Ecto.Query, warn: false

  # TODO: get it dinamically
  def get_user_plan(_user_id, :team_leagues) do
    "number_one_fan" |> String.to_atom()
  end

  def get_user_plan(_user_id, _) do
    "free" |> String.to_atom()
  end

  def get_user_plan_limits(user_plan, league_type) do
    envs = Application.fetch_env!(:stake_lane_api, :limits)

    case envs[user_plan][league_type] do
      nil -> {:error, "Plan does not exist (#{user_plan}/#{league_type})"}
      plan_limits -> {:ok, plan_limits}
    end
  end
end
