defmodule StakeLaneApiWeb.V1.Country.CountriesController do
  use StakeLaneApiWeb, :controller

  alias StakeLaneApi.Country

  def index(conn, _) do

    Country.list_countries
    |> case do
      countries ->
        conn
        |> put_status(200)
        |> json(countries)
    end
  end

end
