defmodule StakeLaneApiWeb.API.V1.RegistrationControllerTest do
  use StakeLaneApiWeb.ConnCase

  @password "secret1234"

  describe "create/2" do
    @valid_params %{"user" => %{"email" => "test@example.com", "password" => @password, "password_confirmation" => @password, "user_name" => "test"}}
    @invalid_params %{"user" => %{"email" => "invalid", "password" => @password, "password_confirmation" => "", "user_name" => "test"}}

    test "with valid params", %{conn: conn} do
      conn = post conn, Routes.api_v1_registration_path(conn, :create, @valid_params)

      assert json = json_response(conn, 200)
      assert json["data"]["access_token"]
      assert json["data"]["renewal_token"]
    end

    test "with invalid params", %{conn: conn} do
      conn = post conn, Routes.api_v1_registration_path(conn, :create, @invalid_params)

      assert json = json_response(conn, 400)
      assert json["error"]["message"] == "Couldn't create the user"
      assert json["error"]["status"] == 400
      assert json["error"]["errors"]["password_confirmation"] == ["does not match confirmation"]
      assert json["error"]["errors"]["email"] == ["has invalid format"]
    end
  end
end
