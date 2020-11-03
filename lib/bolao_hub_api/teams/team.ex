defmodule BolaoHubApi.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset
  alias BolaoHubApi.Countries.Country

  schema "teams" do
    field :name,                       :string
    field :full_name,                  :string
    field :logo,                       :string
    field :is_national,                :boolean
    field :founded,                    :integer
    belongs_to :country,               Country
    embeds_one :venue,                 BolaoHubApi.Teams.Venue, on_replace: :update
    embeds_many :third_parties_info,   BolaoHubApi.Teams.ThirdPartyInfo

    timestamps()
  end

  def changeset(info, attrs) do
    info
    |> cast(attrs, [
      :name,
      :full_name,
      :logo,
      :is_national,
      :country_id,
      :founded,
    ])
    |> cast_embed(:venue)
    |> cast_embed(:third_parties_info)
    |> validate_required([:name])
  end
end

defmodule BolaoHubApi.Teams.Venue do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name,       :string
    field :surface,    :string
    field :address,    :string
    field :city,       :string
    field :capacity,   :integer
  end

  def changeset(info, attrs) do
    info
    |> cast(attrs, [:name, :surface, :address, :city, :capacity])
    |> validate_required([:name, :city])
  end
end

defmodule BolaoHubApi.Teams.ThirdPartyInfo do
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
