defmodule BolaoHubApi.RelevantActions.RelevantAction do
  use Ecto.Schema
  use Pow.Ecto.Schema
  import Ecto.Changeset
  alias BolaoHubApi.Users.User
  alias BolaoHubApi.RelevantAction

  schema "relevant_actions" do
    belongs_to :user, User
    field :user_agent, :string
    field :action, :string
    field :ip_info, :map
    field :ip_coordinates, Geo.PostGIS.Geometry

    pow_user_fields()
    timestamps()
  end

  def changeset(relevant_action, attrs) do
    relevant_action
    |> cast(attrs, [:user_id, :action, :ip_info, :ip_coordinates, :user_agent])
    |> validate_change(:action, fn :action, action ->
      action_allowed = RelevantAction.relevant_actions_values |> Enum.member?(action)
      if action_allowed do
        []
      else
        [action: "not allowed action: #{action}"]
      end
    end)
  end

end
