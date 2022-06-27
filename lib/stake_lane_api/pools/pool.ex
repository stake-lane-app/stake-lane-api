defmodule StakeLaneApi.Pools.Pool do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias StakeLaneApi.Football.{League, Team}

  @derive {Jason.Encoder,
           only: [
             :id,
             :name
           ]}

  schema "pools" do
    field :name, :string
    timestamps()

    belongs_to :league, League
    belongs_to :team, Team
  end

  def changeset(info, attrs) do
    info
    |> cast(attrs, [
      :name,
      :league_id,
      :team_id
    ])
    |> validate_required([:name])
  end
end
