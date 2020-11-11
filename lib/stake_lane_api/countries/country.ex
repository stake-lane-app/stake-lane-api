defmodule StakeLaneApi.Countries.Country do
  use Ecto.Schema
  import Ecto.Changeset
  alias StakeLaneApi.Teams.Team
  alias StakeLaneApi.Leagues.League

  @derive {Jason.Encoder, only: [
    :id,
    :name,
    :code,
    :flag,
  ]}

  schema "countries" do
    field :name,        :string
    field :code,        :string
    field :flag,        :string

    timestamps()

    has_many :teams, Team
    has_many :league, League
  end

  def changeset(info, attrs) do
    info
    |> cast(attrs, [:name, :code, :flag])
    |> validate_required([:name, :code])
    |> unique_constraint([:name])
  end
end
