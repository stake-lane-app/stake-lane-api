defmodule BolaoHubApi.Fixtures.Fixture do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias BolaoHubApi.Leagues.League
  alias BolaoHubApi.Teams.Team

  @derive {Jason.Encoder, only: [
    :goals_home_team,
    :goals_away_team,
    :starts_at_iso_date,
    :event_timestamp,
    :status_code,
    :elapsed,
    :venue,
    :referee,
    :home_team,
    :away_team,
    :score,
    # :league,
  ]}

  schema "fixtures" do
    belongs_to :league,                League
    belongs_to :home_team,             Team
    belongs_to :away_team,             Team
    embeds_one :score,                 BolaoHubApi.Fixtures.Score, on_replace: :update
    embeds_many :third_parties_info,   BolaoHubApi.Fixtures.ThirdPartyInfo

    field :goals_home_team,     :integer
    field :goals_away_team,     :integer
    field :starts_at_iso_date,  :utc_datetime
    field :event_timestamp,     :integer
    field :status_code,         :string
    field :elapsed,             :integer
    field :venue,               :string
    field :referee,             :string

    timestamps()

    field :third_party_info, :map, virtual: true
  end

  def changeset(info, attrs) do
    info
    |> cast(attrs, [
      :goals_home_team,
      :goals_away_team,
      :starts_at_iso_date,
      :event_timestamp,
      :status_code,
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
      :starts_at_iso_date,
      :event_timestamp,
    ])
    |> unique_constraint([:home_team_id, :away_team_id, :event_timestamp])
  end
end

defmodule BolaoHubApi.Fixtures.Score do
  @moduledoc false

  @derive {Jason.Encoder, only: [
    :halftime,
    :fulltime,
    :extratime,
    :penalty,
  ]}

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
  @moduledoc false

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
    |> cast(attrs, [:api, :fixture_id, :league_id, :respectness])
    |> validate_required([:api, :fixture_id, :league_id])
  end
end

defmodule BolaoHubApi.Fixtures.Status do
  @moduledoc false

  def fixtures_status() do
    %{
      to_be_defined: %{
        code: "TBD",
        description: "Time To Be Defined",
      },
      not_started: %{
        code: "NS",
        description: "Not Started",
      },
      first_half: %{
        code: "1H",
        description: "First Half",
      },
      half_time: %{
        code: "HT",
        description: "Halftime",
      },
      second_half: %{
        code: "2H",
        description: "Second Half",
      },
      extra_time: %{
        code: "ET",
        description: "Extra Time",
      },
      penalties: %{
        code: "P",
        description: "Penalty In Progress",
      },
      finished: %{
        code: "FT",
        description: "Match Finished",
      },
      extra_time_finished: %{
        code: "AET",
        description: "Match Finished After Extra Time",
      },
      penalties_finished: %{
        code: "PEN",
        description: "Match Finished After Penalty",
      },
      break_time: %{
        code: "BT",
        description: "Break Time (in Extra Time)",
      },
      suspended: %{
        code: "SUSP",
        description: "Match Suspended",
      },
      interrupted: %{
        code: "INT",
        description: "Match Interrupted",
      },
      postponed: %{
        code: "PST",
        description: "Match Postponed",
      },
      cancelled: %{
        code: "CANC",
        description: "Match Cancelled",
      },
      abandoned: %{
        code: "ABD",
        description: "Match Abandoned",
      },
      technial_loss: %{
        code: "AWD",
        description: "Technical Loss",
      },
      walkover: %{
        code: "WO",
        description: "Walkover",
      }
    }
  end

  def finished_status_codes() do
    [
      fixtures_status()[:finished][:code],
      fixtures_status()[:extra_time_finished][:code],
      fixtures_status()[:penalties_finished][:code],
    ]
  end

  def running_status_codes() do
    [
      fixtures_status()[:first_half][:code],
      fixtures_status()[:half_time][:code],
      fixtures_status()[:second_half][:code],
      fixtures_status()[:extra_time][:code],
      fixtures_status()[:break_time][:code],
      fixtures_status()[:penalties][:code],
    ]
  end

  def get_by_code(code) do
    {_, fixture_status} = fixtures_status()
    |> Enum.find(fn {_, value} -> (value.code == code) end)

    fixture_status
  end
end
