defmodule StakeLaneApiWeb.API.V1.Country.CountriesControllerTest do
  use StakeLaneApiWeb.ConnCase
  import StakeLaneApi.Factory

  describe "list/2" do
    setup %{conn: conn} do
      insert_list(3, :country)

      authed_conn = Pow.Plug.assign_current_user(conn, insert(:user), [])
      {:ok, authed_conn: authed_conn}
    end

    test "with valid params", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.api_v1_countries_path(authed_conn, :index))
      assert countries = json_response(conn, 200)
      assert false === Enum.empty?(countries)

      Enum.map(countries, fn country ->
        assert Map.has_key?(country, "code")
        assert Map.has_key?(country, "flag")
        assert Map.has_key?(country, "id")
        assert Map.has_key?(country, "name")
      end)
    end
  end
end
