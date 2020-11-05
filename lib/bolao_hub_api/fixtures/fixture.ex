defmodule BolaoHubApi.Fixtures.Fixture do
  use Ecto.Schema
  import Ecto.Changeset
  alias BolaoHubApi.Leagues.League
  alias BolaoHubApi.Teams.Team

  schema "teams" do
    belongs_to :league,                League
    belongs_to :home_team,             Team
    belongs_to :away_team,             Team
    embeds_one :score,                 BolaoHubApi.Fixtures.Score, on_replace: :update
    embeds_many :third_parties_info,   BolaoHubApi.Fixtures.ThirdPartyInfo

    field :goals_home_team,     :integer
    field :goals_away_team,     :integer
    field :event_date,          :utc_datetime
    field :event_timestamp,     :integer
    field :status_short,        :string
    field :elapsed,             :integer
    field :venue,               :string
    field :referee,             :string

    timestamps()
  end

  def changeset(info, attrs) do
    info
    |> cast(attrs, [
      :goals_home_team,
      :goals_away_team,
      :event_date,
      :event_timestamp,
      :status_short,
      :elapsed,
      :venue,
      :referee,
      :league_id,
      :home_team_id,
      :away_team_id,
    ])
    |> cast_embed(:score)
    |> cast_embed(:third_parties_info)
    |> validate_required([
      :league_id,
      :home_team_id,
      :away_team_id,
      :event_date,
      :event_timestamp,
    ])
  end
end

defmodule BolaoHubApi.Fixture.Score do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :halftime,    :string
    field :fulltime,    :string
    field :extratime,   :string
    field :penalty,     :string
  end

  def changeset(info, attrs) do
    info
    |> cast(attrs, [:halftime, :fulltime, :extratime, :penalty])
    |> validate_required([])
  end
end

defmodule BolaoHubApi.Fixtures.ThirdPartyInfo do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :api,         :string
    field :fixture_id,  :integer
    field :league_id,   :integer
    field :round,       :string
    field :respectness, :integer
  end

  def changeset(info, attrs) do
    info
    |> cast(attrs, [:api, :fixture_id, :league_id, :round, :respectness])
    |> validate_required([:api, :fixture_id, :league_id])
  end
end
