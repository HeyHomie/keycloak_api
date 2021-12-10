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
        |> Plug.Conn.put_resp_header("Location", "http://localhost:8080/auth/admin/realms/master/users/#{@user_id}")
        |> Plug.Conn.put_resp_header("X-Frame-Optionse", "SAMEORIGIN")
        |> Plug.Conn.resp(201, "")
      end)

      assert User.create(@valid_params, "admin-access-token") == {:ok, "http://localhost:8080/auth/admin/realms/master/users/#{@user_id}"}
    end
  end

end
