defmodule StakeLaneApiWeb.API.V1.League.LeaguesControllerTest do
  use StakeLaneApiWeb.ConnCase
  import StakeLaneApi.Factory

  describe "list/2" do
    setup %{conn: conn} do
      insert_list(2, :league, country: insert(:country))
      insert_list(2, :league, country: insert(:country))

      authed_conn = Pow.Plug.assign_current_user(conn, insert(:user), [])
      {:ok, authed_conn: authed_conn}
    end

    test "with valid params", %{authed_conn: authed_conn} do
      conn = get authed_conn, Routes.api_v1_leagues_path(authed_conn, :index)
      assert leagues = json_response(conn, 200)
      assert false === Enum.empty?(leagues)
      Enum.map(leagues, fn league ->
        assert Map.has_key?(league, "active")
        assert Map.has_key?(league, "country")
        assert Map.has_key?(league, "league_id")
        assert Map.has_key?(league, "name")
        assert Map.has_key?(league, "season")
      end)
    end

  end
end
