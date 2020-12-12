defmodule StakeLaneApi.Finances.Plan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plans" do
    field :name, Ecto.Enum,
      values: [:free, :number_one_fan, :four_four_two, :stake_horse, :top_brass]

    field :price, Money.Ecto.Composite.Type
    field :valid, :boolean
    field :selectable, :boolean

    timestamps()
  end

  def changeset(changeset, attrs) do
    changeset
    |> cast(attrs, [
      :plan,
      :price,
      :valid,
      :selectable
    ])
    |> validate_required([
      :plan,
      :price,
      :valid,
      :selectable
    ])
    |> unique_constraint([:name, :price, :selectable])
  end
end

defmodule StakeLaneApi.Finances.Plan.Types do
  defp unlimited_plan() do
    %{
      leagues: 300,
      team_leagues: 300,
      pools: 5_000
    }
  end

  defp free_leagues_given(), do: 2

  def plans() do
    %{
      free: %{
        leagues: free_leagues_given(),
        team_leagues: 0,
        pools: 1
      },
      number_one_fan: %{
        leagues: free_leagues_given(),
        team_leagues: 1,
        pools: 10
      },
      four_four_two: %{
        leagues: 10,
        team_leagues: 0,
        pools: 10
      },
      stake_horse: unlimited_plan(),
      top_brass: unlimited_plan()
    }
  end

  defp plans_list() do
    plans() |> Enum.map(fn {key, _} -> key end)
  end

  def is_plan_allowed?(plan) do
    plan in plans_list()
  end
end

defmodule StakeLaneApi.Finances.Plan.Currencies do
  defp acceptable_currencies() do
    [
      :USD,
      :EUR,
      :GBP,
      :BRL,
      :MXN
    ]
  end

  def is_currency_allowed?(currency) do
    currency in acceptable_currencies()
  end
end
