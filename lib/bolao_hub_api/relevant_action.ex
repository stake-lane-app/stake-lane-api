defmodule BolaoHubApi.RelevantAction do
  @moduledoc """
  The RelevantAction context.
  """
  
  require Logger
  import Ecto.Query, warn: false
  alias BolaoHubApi.Repo
  alias BolaoHubApiWeb.Utils.IpLocation

  alias BolaoHubApi.RelevantActions.RelevantAction

  def relevant_actions() do
    %{
      Registered: "registered",
      Login: "login",
    }
  end

  def relevant_actions_values() do
    Map.values(relevant_actions())
  end

  def get_coordinates(ip_info) do
    with true <- !is_nil(ip_info[:longitude]) do
      %Geo.Point{coordinates: {ip_info[:longitude], ip_info[:latitude]}, srid: 4326}
    else
      _ -> nil
    end
  end

  def create(action, user_id, remote_ip) do
    attrs = IpLocation.get_ip_info(remote_ip)
      |> case do
      ip_info when is_map(ip_info) ->
        %{
          ip_info: ip_info,
          ip_coordinates: ip_info |> get_coordinates,
          action: action,
          user_id: user_id,
        }
      _ -> 
        %{
          ip_info: %{remote_ip: remote_ip |> Tuple.to_list},
          action: action,
          user_id: user_id,
        }
    end

    %RelevantAction{}
      |> RelevantAction.changeset(attrs)
      |> Repo.insert()
      |> case do
        {:error, log} -> Logger.error(inspect(log.errors))
        _ -> nil
      end
  end

end
