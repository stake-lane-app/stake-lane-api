defmodule StakeLaneApi.Pools.PoolParticipant do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias StakeLaneApi.Users.User
  alias StakeLaneApi.Pools.Pool

  @derive {Jason.Encoder,
           only: [
             :id,
             :captain,
             :blocked
           ]}

  schema "pools_participants" do
    field :captain, :boolean
    field :blocked, :boolean
    timestamps()

    belongs_to :pool, Pool
    belongs_to :user, User
  end

  def changeset(info, attrs) do
    info
    |> cast(attrs, [
      :captain,
      :blocked,
      :pool_id,
      :user_id
    ])
    |> validate_required([
      :captain,
      :pool_id,
      :user_id
    ])
  end
end
