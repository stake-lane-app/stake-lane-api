defmodule BolaoHubApiWeb.Utils.IpLocation do
  @moduledoc false

  alias Plug.Conn

  defp parse_geo_data(geo_data) do
    %{
      latitude: geo_data |> Map.get(:location, %{}) |> Map.get(:latitude),
      longitude: geo_data |> Map.get(:location, %{}) |> Map.get(:longitude),
      time_zone: geo_data |> Map.get(:location, %{}) |> Map.get(:time_zone),
      city: geo_data |> Map.get(:city, %{}) |> Map.get(:name),
      country: geo_data |> Map.get(:country, %{}) |> Map.get(:name),
      is_in_european_union: geo_data |> Map.get(:country, %{}) |> Map.get(:is_in_european_union),
      iso_code: geo_data |> Map.get(:country, %{}) |> Map.get(:iso_code),
      remote_ip: geo_data |> Map.get(:traits, %{}) |> Map.get(:ip_address) |> Tuple.to_list
    }
  end

  @type ip_info :: %{
    city: String.t,
    country: String.t,
    is_in_european_union: boolean,
    iso_code: String.t,
    latitude: float,
    longitude: float,
    time_zone: String.t,
    remote_ip: List,
  }

  @spec get_ip_info(Conn.t()) :: nil | ip_info
  def get_ip_info(remote_ip) do
    Geolix.lookup(remote_ip)[:city]
    |> case do
      nil -> nil
      geo_data ->
        geo_data
          |> Map.from_struct()
          |> Enum.filter(fn {_key, value} -> !is_nil(value) end)
          |> Map.new()
          |> parse_geo_data()
    end
  end

  @spec get_ip_from_header(Conn.t()) :: Tuple | String
  def get_ip_from_header(conn) do
    get_ip(conn, Mix.env())
  end

  defp get_ip(conn, env) when env in [:local, :test, :dev], do: conn.remote_ip
  defp get_ip(conn, _) do
    conn
      |> Conn.get_req_header("x-forwarded-for")
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.at(0)
  end
end
