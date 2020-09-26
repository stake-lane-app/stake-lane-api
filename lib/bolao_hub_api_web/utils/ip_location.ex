defmodule BolaoHubApiWeb.Utils.IpLocation do

  @type ip_info :: %{
    city: String.t,
    country: String.t,
    is_in_european_union: boolean,
    iso_code: String.t,
    latitude: float,
    longitude: float,
    time_zone: String.t
  }
  
  @spec get_ip_info(Conn.t()) :: nil | ip_info
  def get_ip_info(remote_ip) do
    Geolix.lookup(remote_ip)[:city]
    |> case do
      nil -> nil
      geo_data -> %{
        latitude: geo_data.location.latitude,
        longitude: geo_data.location.longitude,
        time_zone: geo_data.location.time_zone,
        city: geo_data.city.name,
        country: geo_data.country.name,
        is_in_european_union: geo_data.country.is_in_european_union,
        iso_code: geo_data.country.iso_code,
        remote_ip: Tuple.to_list(remote_ip)
      }
    end
  end

end