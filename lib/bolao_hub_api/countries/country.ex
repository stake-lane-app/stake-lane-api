defmodule BolaoHubApi.Countries.Country do
  use Ecto.Schema
  import Ecto.Changeset

  alias BolaoHubApi.Teams.Team

  schema "countries" do
    field :name,        :string
    field :code,        :string
    field :flag,        :string

    timestamps()

    has_many :teams, Team
  end

  def changeset(info, attrs) do
    info
    |> cast(attrs, [:name, :code, :flag])
    |> validate_required([:name, :code])
    |> unique_constraint([:name])
  end
end
