defmodule BolaoHubApi.Leagues.League do
  use Ecto.Schema
  import Ecto.Changeset

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
  end
end

defmodule BolaoHubApi.Leagues.ThirdPartyInfo do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :api, :string
    field :league_id, :integer

    field :respectness, :integer
    # 'respectness' will be the the level of force the 3rd-api/admin has
    # In order to have somebody that can overwrite
    # the persisted data (Match results, Active leagues, etc), 
    # we will need to have a higher respectness

    def changeset(info, attrs) do
      info
      |> cast(attrs, [:api, :league_id, :respectness])
      |> validate_required([:api, :league_id])
    end
  end
end
