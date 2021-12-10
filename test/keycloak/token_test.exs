defmodule KeycloakAPI.TokenTest do
  use ExUnit.Case

  alias KeycloakAPI.Token

  setup do
    bypass = Bypass.open()
    bypass_url = "http://localhost:#{bypass.port}"
    Application.put_env(:keycloak_api, :site, bypass_url)
    {:ok, bypass: bypass}
  end

  describe "get_admin_access_token/0" do
    test "when request is success", %{bypass: bypass} do
      token_response = %{
        "access_token" => "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lk",
        "expires_in" => 60,
        "not-before-policy" => 0,
        "refresh_expires_in" => 0,
        "scope" => "profile email",
        "token_type" => "Bearer"
      }

      Bypass.expect(bypass, fn conn ->
        assert conn.request_path == "/realms/master/protocol/openid-connect/token"
        assert conn.method == "POST"

        Plug.Conn.resp(conn, 200, Jason.encode!(token_response))
      end)

      assert Token.get_admin_access_token() ==
               {:ok,
                %{
                  "access_token" => "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lk",
                  "expires_in" => 60,
                  "not-before-policy" => 0,
                  "refresh_expires_in" => 0,
                  "scope" => "profile email",
                  "token_type" => "Bearer"
                }}
    end
  end
end
