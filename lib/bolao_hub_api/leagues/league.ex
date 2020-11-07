defmodule BolaoHubApi.Leagues.League do
  @moduledoc false

    @derive {Jason.Encoder, only: [
    :name,
    :country,
    :country_code,
    :season,
    :season_start,
    :season_end,
    :active,
    :fixtures
  ]}

  use Ecto.Schema
  import Ecto.Changeset
  alias BolaoHubApi.Fixtures.Fixture

  schema "leagues" do
    field :name,             :string
    field :country,          :string
    field :country_code,     :string
    field :season,           :integer
    field :season_start,     :date
    field :season_end,       :date
    field :active,           :boolean
    embeds_many :third_parties_info, BolaoHubApi.Leagues.ThirdPartyInfo

    timestamps()

    has_many :fixtures, Fixture

    field :third_party_info, :map, virtual: true
  end

  def changeset(info, attrs) do
    info
    |> cast(attrs, [
      :name,
      :country,
      :country_code,
      :season,
      :season_start,
      :season_end,
      :active,
    ])
    |> cast_embed(:third_parties_info)
    |> validate_required([:name, :country, :country_code, :season, :active])
    |> unique_constraint([:name, :country_code, :season])
  end
end

defmodule BolaoHubApi.Leagues.ThirdPartyInfo do
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
