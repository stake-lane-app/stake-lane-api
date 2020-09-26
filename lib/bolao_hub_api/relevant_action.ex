defmodule BolaoHubApi.RelevantAction do
  @moduledoc """
  The RelevantAction context.
  """
  
  require Logger
  import Ecto.Query, warn: false
  alias BolaoHubApi.Repo
  alias BolaoHubApiWeb.Utils.IpLocation

  alias BolaoHubApi.RelevantActions.RelevantAction

  def relevantActions() do
    %{
      Registered: "registered",
      Login: "login",
    }
  end

  def relevantActionsValues() do
    Map.values(relevantActions())
  end

  def create(action, user_id, remote_ip) do
    attrs = IpLocation.get_ip_info(remote_ip)
      |> case do
      ip_info when is_map(ip_info) ->
        %{
          ip_info: ip_info,
          ip_coordinates: %Geo.Point{coordinates: {ip_info[:longitude], ip_info[:latitude]}, srid: 4326},
          action: action,
          user_id: user_id,
        }

      _ -> 
        %{
          action: action,
          user_id: user_id,
        }
    end

    %RelevantAction{}
    |> RelevantAction.changeset(attrs)
    |> Repo.insert()
    |> case  do
      {:error, log} -> Logger.error(inspect(log.errors))
      _ -> nil
    end
  end

end
