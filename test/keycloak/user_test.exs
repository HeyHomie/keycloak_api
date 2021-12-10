defmodule KeycloakAPI.UserTest do
  use ExUnit.Case, async: true

  alias KeycloakAPI.User

  @user_id "f2920937-ab8c-47fd-ac5a-4089707012b4"

  @valid_params %{
    "firstName" => "Brandon",
    "lastName" => "Springer",
    "email" => "test@test.com",
    "enabled" => "true",
    "username" => "test@test.com",
    "emailVerified" => "true",
    "credentials" => [
      %{
        "type" => "password",
        "temporary" => false,
        "value" => "123456"
      }
    ]
  }

  @show_user_success_response %{
    "id" => @user_id,
    "createdTimestamp" => 1_635_967_633_697,
    "username" => "test2@test.com",
    "enabled" => true,
    "totp" => false,
    "emailVerified" => true,
    "firstName" => "Brandon",
    "lastName" => "Springer",
    "email" => "test2@test.com",
    "disableableCredentialTypes" => [],
    "requiredActions" => [],
    "notBefore" => 0,
    "access" => %{
      "manageGroupMembership" => true,
      "view" => true,
      "mapRoles" => true,
      "impersonate" => true,
      "manage" => true
    }
  }

  setup do
    bypass = Bypass.open()
    bypass_url = "http://localhost:#{bypass.port}"
    Application.put_env(:keycloak_api, :site, bypass_url)
    {:ok, bypass: bypass}
  end

  describe "create/2" do
    test "when request is success", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert conn.request_path == "/admin/realms/master/users"
        assert conn.method == "POST"

        conn
        |> Plug.Conn.put_resp_header(
          "Location",
          "http://localhost:8080/auth/admin/realms/master/users/#{@user_id}"
        )
        |> Plug.Conn.put_resp_header("X-Frame-Optionse", "SAMEORIGIN")
        |> Plug.Conn.resp(201, "")
      end)

      assert User.create(@valid_params, "admin-access-token") ==
               {:ok, "http://localhost:8080/auth/admin/realms/master/users/#{@user_id}"}
    end
  end

  describe "get/2" do
    test "when request is success", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert conn.request_path == "/admin/realms/master/users/#{@user_id}"
        assert conn.method == "GET"

        Plug.Conn.resp(conn, 200, Jason.encode!(@show_user_success_response))
      end)

      expected_user = %{
        "id" => @user_id,
        "createdTimestamp" => 1_635_967_633_697,
        "username" => "test2@test.com",
        "enabled" => true,
        "totp" => false,
        "emailVerified" => true,
        "firstName" => "Brandon",
        "lastName" => "Springer",
        "email" => "test2@test.com",
        "disableableCredentialTypes" => [],
        "requiredActions" => [],
        "notBefore" => 0,
        "access" => %{
          "manageGroupMembership" => true,
          "view" => true,
          "mapRoles" => true,
          "impersonate" => true,
          "manage" => true
        }
      }

      assert User.get(@user_id, "admin-access-token") == {:ok, expected_user}
    end
  end
end
