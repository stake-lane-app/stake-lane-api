defmodule StakeLaneApi.Finances.Plan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "plans" do
    field :plan, Ecto.Enum,
      values: [:free, :number_one_fan, :four_four_two, :stake_horse, :top_brass]

    field :price, Money.Currency.Ecto.Type

    # free Money.Currency.usd(0) OR %Money{amount: 0, currency: :USD},

    # number_one_fan Money.Currency.usd(1_50) OR %Money{amount: 1_50, currency: :USD},
    # number_one_fan Money.Currency.eur(1_50) OR %Money{amount: 1_50, currency: :EUR},
    # number_one_fan Money.Currency.gbp(1_50) OR %Money{amount: 1_50, currency: :GBP},
    # number_one_fan Money.Currency.brl(5_00) OR %Money{amount: 5_00, currency: :BRL},
    # number_one_fan Money.Currency.mxn(50_00) OR %Money{amount: 50_00, currency: :MXN},

    # four_four_two Money.Currency.usd(3_00) OR %Money{amount: 3_00, currency: :USD},
    # four_four_two Money.Currency.eur(3_00) OR %Money{amount: 3_00, currency: :EUR},
    # four_four_two Money.Currency.gbp(3_00) OR %Money{amount: 3_00, currency: :GBP},
    # four_four_two Money.Currency.brl(8_00) OR %Money{amount: 8_00, currency: :BRL},
    # four_four_two Money.Currency.mxn(80_00) OR %Money{amount: 80_00, currency: :MXN},

    # stake_horse Money.Currency.usd(5_00) OR %Money{amount: 5_00, currency: :USD},
    # stake_horse Money.Currency.eur(5_00) OR %Money{amount: 5_00, currency: :EUR},
    # stake_horse Money.Currency.gbp(5_00) OR %Money{amount: 5_00, currency: :GBP},
    # stake_horse Money.Currency.brl(10_00) OR %Money{amount: 10_00, currency: :BRL},
    # stake_horse Money.Currency.mxn(100_00) OR %Money{amount: 100_00, currency: :MXN},

    # top_brass Money.Currency.usd(0) OR %Money{amount: 0, currency: :USD},

    timestamps()
  end

  def changeset(changeset, attrs) do
    changeset
    |> cast(attrs, [
      :plan,
      :price
    ])
    |> validate_required([
      :plan,
      :price
    ])
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

  def plans_list() do
    plans() |> Enum.map(fn {key, _} -> key end)
  end
end
