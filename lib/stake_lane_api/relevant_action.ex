defmodule StakeLaneApi.RelevantAction do
  @moduledoc """
  The RelevantAction context.
  """

  require Logger
  import Ecto.Query, warn: false
  alias StakeLaneApiWeb.Utils.IpLocation
  alias StakeLaneApi.Repo
  alias StakeLaneApi.Users.RelevantAction

  def relevant_actions() do
    %{
      Registered: "registered",
      Login: "login"
    }
  end

  def relevant_actions_values() do
    relevant_actions() |> Map.values()
  end

  defp get_coordinates(_, nil), do: nil

  defp get_coordinates(ip_info, _) do
    %Geo.Point{
      coordinates: {
        ip_info[:longitude],
        ip_info[:latitude]
      },
      srid: 4326
    }
  end

  def create(action, user_id, remote_ip, user_agent) do
    ip_attrs =
      IpLocation.get_ip_info(remote_ip)
      |> case do
        ip_info when is_map(ip_info) ->
          %{
            ip_info: ip_info,
            ip_coordinates: ip_info |> get_coordinates(ip_info[:longitude])
          }

        _ ->
          %{
            remote_ip: remote_ip |> Tuple.to_list()
          }
      end

    attrs =
      ip_attrs
      |> Map.merge(%{
        action: action,
        user_id: user_id,
        user_agent: user_agent
      })

    %RelevantAction{}
    |> RelevantAction.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:error, log} -> Logger.error(inspect(log.errors))
      _ -> nil
    end
  end
end
