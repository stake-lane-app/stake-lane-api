defmodule StakeLaneApi.Users.Prediction do
  use Ecto.Schema
  import Ecto.Changeset
  alias StakeLaneApi.Users.User
  alias StakeLaneApi.Football.Fixture

  @derive {Jason.Encoder, only: [
    :home_team,
    :away_team,
    :score,
    :finished,
  ]}

  schema "predictions" do
    belongs_to :user, User
    belongs_to :fixture, Fixture
    field :home_team, :integer
    field :away_team, :integer
    field :score,     :integer
    field :finished,  :boolean

    timestamps()
  end

  def changeset(prediction, attrs) do
    prediction
    |> cast(attrs, [
      :user_id,
      :fixture_id,
      :home_team,
      :away_team,
      :score,
      :finished,
    ])
    |> validate_required([
      :user_id,
      :fixture_id,
      :home_team,
      :away_team
    ])
    |> unique_constraint([:user_id, :fixture_id])
  end

end
