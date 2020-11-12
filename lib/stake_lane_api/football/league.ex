defmodule StakeLaneApi.Football.League do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias StakeLaneApi.Football.Fixture
  alias StakeLaneApi.Countries.Country

  @derive {Jason.Encoder, only: [
    :id,
    :name,
    :season,
    :season_start,
    :season_end,
    :active,
    :fixtures,
    :country,
  ]}

  schema "leagues" do
    field :name,             :string
    field :season,           :integer
    field :season_start,     :date
    field :season_end,       :date
    field :active,           :boolean
    embeds_many :third_parties_info, StakeLaneApi.Football.League.ThirdPartyInfo

    timestamps()

    belongs_to :country, Country
    has_many :fixtures, Fixture

    field :third_party_info, :map, virtual: true
  end

  def changeset(info, attrs) do
    info
    |> cast(attrs, [
      :name,
      :country_id,
      :season,
      :season_start,
      :season_end,
      :active,
    ])
    |> cast_embed(:third_parties_info)
    |> validate_required([:name, :country_id, :season, :active])
    |> unique_constraint([:name, :country_id, :season])
  end
end

defmodule StakeLaneApi.Football.League.ThirdPartyInfo do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :api, :string
    field :league_id, :integer
    field :respectness, :integer

    def changeset(info, attrs) do
      info
      |> cast(attrs, [:api, :league_id, :respectness])
      |> validate_required([:api, :league_id])
    end
  end
end
