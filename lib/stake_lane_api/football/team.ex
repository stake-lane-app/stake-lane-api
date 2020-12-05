defmodule StakeLaneApi.Football.Team do
  use Ecto.Schema
  import Ecto.Changeset
  alias StakeLaneApi.Countries.Country
  alias StakeLaneApi.Links.UserTeamLeague
  alias StakeLaneApi.Football.Fixture

  @derive {Jason.Encoder,
           only: [
             :id,
             :name,
             :full_name,
             :logo,
             :is_national,
             :founded,
             :venue,
             :country
           ]}

  schema "teams" do
    field :name, :string
    field :full_name, :string
    field :logo, :string
    field :is_national, :boolean
    field :founded, :integer
    belongs_to :country, Country
    embeds_one :venue, StakeLaneApi.Football.Team.Venue, on_replace: :update
    embeds_many :third_parties_info, StakeLaneApi.Football.Team.ThirdPartyInfo

    timestamps()

    has_many :fixtures_home, Fixture, foreign_key: :home_team_id, references: :id
    has_many :fixtures_away, Fixture, foreign_key: :away_team_id, references: :id
    has_many :user_team_league, UserTeamLeague

    field :third_party_info, :map, virtual: true
  end

  def changeset(info, attrs) do
    info
    |> cast(attrs, [
      :name,
      :full_name,
      :logo,
      :is_national,
      :country_id,
      :founded
    ])
    |> cast_embed(:venue)
    |> cast_embed(:third_parties_info)
    |> validate_required([:name])
    |> unique_constraint([:name, :country_id])
  end
end

defmodule StakeLaneApi.Football.Team.Venue do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :name,
             :surface,
             :address,
             :city,
             :capacity
           ]}

  embedded_schema do
    field :name, :string
    field :surface, :string
    field :address, :string
    field :city, :string
    field :capacity, :integer
  end

  def changeset(info, attrs) do
    info
    |> cast(attrs, [:name, :surface, :address, :city, :capacity])
  end
end

defmodule StakeLaneApi.Football.Team.ThirdPartyInfo do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :api, :string
    field :team_id, :integer
    field :respectness, :integer
  end

  def changeset(info, attrs) do
    info
    |> cast(attrs, [:api, :team_id, :respectness])
    |> validate_required([:api, :team_id])
  end
end
