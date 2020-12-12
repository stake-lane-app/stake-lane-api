defmodule StakeLaneApi.Plan do
  @moduledoc """
  The UserPlan context.
  """

  import Ecto.Query, warn: false
  alias StakeLaneApi.Repo
  alias StakeLaneApi.Finances.Plan

  def get_plan(plan_name \\ :free, currency \\ :USD) do
    {
      Plan.Currencies.is_currency_allowed?(currency),
      Plan.Types.is_plan_allowed?(plan_name)
    }
    |> case do
      {true, true} ->
        query =
          from plan in Plan,
            where:
              plan.name == ^plan_name and
              plan.valid == true and
              plan.selectable == true

        query
        |> Repo.all()
        |> Enum.find(fn plan -> plan.price.currency == currency end)

      {false, _} ->
        {:error, "Currency #{currency} not allowed"}

      {_, false} ->
        {:error, "Plan #{plan_name} not allowed"}
    end
  end
end
