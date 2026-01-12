defmodule StakeLaneApi.PoolParticipant do
  @moduledoc """
  The PoolParticipant context.
  """

  import Ecto.Query, warn: false
  alias StakeLaneApi.Pools.PoolParticipant
  alias StakeLaneApi.Repo

  def user_pools_quantity(user_id) do
    query =
      from pp in PoolParticipant,
        where: pp.user_id == ^user_id and pp.blocked == false

    query
    |> Repo.all()
    |> length
  end
end
