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
  
  @spec get_ip_info(Conn.t()) :: %{}, ip_info
  def get_ip_info(conn) do
    ip_info = 
      Geolix.lookup(conn.remote_ip)
      # Geolix.lookup({191, 96, 73, 229})
      |> case do
        %{city: nil} -> %{}
        geo_data -> %{
          latitude: geo_data.city.location.latitude,
          longitude: geo_data.city.location.longitude,
          time_zone: geo_data.city.location.time_zone,
          city: geo_data.city.city.name,
          country: geo_data.city.country.name,
          is_in_european_union: geo_data.city.country.is_in_european_union,
          iso_code: geo_data.city.country.iso_code,
        }
      end

    ip_info
  end

end