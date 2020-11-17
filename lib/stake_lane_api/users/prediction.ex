defmodule StakeLaneApi.Users.Prediction do
  use Ecto.Schema
  import Ecto.Changeset
  alias StakeLaneApi.Users.User
  alias StakeLaneApi.Football.Fixture

  schema "predictions" do
    belongs_to :user, User
    belongs_to :fixture, Fixture
    field :home_team, :integer
    field :away_team, :integer

    timestamps()
  end

  def changeset(prediction, attrs) do
    prediction
    |> unique_constraint([:user_id, :fixture_id])
    |> cast(attrs, [
      :home_team,
      :away_team
    ])
    |> validate_required([
      :user_id,
      :fixture_id,
      :home_team,
      :away_team
    ])
  end

end
