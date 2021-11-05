defmodule KeycloakAPITest do
  use ExUnit.Case

  import Tesla.Mock

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

  @success_admin_token_response %{
    "access_token" => "your-token",
    "expires_in" => 60,
    "refresh_expires_in" => 0,
    "token_type" => "Bearer",
    "not-before-policy" => 0,
    "scope" => "profile email"
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
    mock(fn
      %{
        method: :post,
        url: "http://localhost:8080/auth/realms/master/protocol/openid-connect/token"
      } ->
        %Tesla.Env{status: 200, body: @success_admin_token_response}

      %{method: :post, url: "http://localhost:8080/auth/admin/realms/master/users"} ->
        %Tesla.Env{
          status: 201,
          body: nil,
          headers: [
            {"Location", "http://localhost:8080/auth/admin/realms/master/users/#{@user_id}"},
            {"X-Frame-Options", "SAMEORIGIN"}
          ]
        }

      %{method: :get, url: "http://localhost:8080/auth/admin/realms/master/users/#{@user_id}"} ->
        %Tesla.Env{status: 200, body: @show_user_success_response}
    end)

    :ok
  end

  describe "create_user/1" do
    test "with valid params" do
      assert KeycloakAPI.create_user(@valid_params) ==
               {:ok,
                %{
                  user_loaction:
                    "http://localhost:8080/auth/admin/realms/master/users/#{@user_id}"
                }}
    end
  end

  describe "get_user/1" do
    test "with valid id" do
      assert KeycloakAPI.get_user("#{@user_id}") == {:ok, @show_user_success_response}
    end
  end
end
