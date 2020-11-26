defmodule StakeLaneApi.Football.Fixture do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias StakeLaneApi.Football.League
  alias StakeLaneApi.Football.Team
  alias StakeLaneApi.Users.Prediction

  @derive {Jason.Encoder, only: [
    :id,
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
    :league,
    :prediction,
  ]}

  schema "fixtures" do
    belongs_to :league,                League
    belongs_to :home_team,             Team
    belongs_to :away_team,             Team
    has_one    :prediction,            Prediction
    embeds_one :score,                 StakeLaneApi.Football.Fixture.Score, on_replace: :update
    embeds_many :third_parties_info,   StakeLaneApi.Football.Fixture.ThirdPartyInfo

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

defmodule StakeLaneApi.Football.Fixture.Score do
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

defmodule StakeLaneApi.Football.Fixture.ThirdPartyInfo do
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

defmodule StakeLaneApi.Football.Fixture.Status do
  @moduledoc false

  def fixtures_statuses() do
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
      fixtures_statuses()[:finished][:code],
      fixtures_statuses()[:extra_time_finished][:code],
      fixtures_statuses()[:penalties_finished][:code],
    ]
  end

  def running_status_codes() do
    [
      fixtures_statuses()[:first_half][:code],
      fixtures_statuses()[:half_time][:code],
      fixtures_statuses()[:second_half][:code],
      fixtures_statuses()[:extra_time][:code],
      fixtures_statuses()[:break_time][:code],
      fixtures_statuses()[:penalties][:code],
    ]
  end

  def allow_prediction() do
    [
      fixtures_statuses()[:not_started][:code],
      fixtures_statuses()[:to_be_defined][:code],
    ]
  end

  def get_by_code(code) do
    {_, fixture_status} = fixtures_statuses()
    |> Enum.find(fn {_, value} -> (value.code == code) end)

    fixture_status
  end
end
