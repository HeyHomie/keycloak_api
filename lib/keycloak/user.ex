defmodule KeycloakAPI.User do
  @moduledoc """
  Module to User resource
  """

  alias KeycloakAPI.HTTPClient

  @doc """
  Creates a new user

  ## Example

    params = %{
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

    iex> KeycloakAPI.User.create(params, "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIi...")
    {:ok,
      "http://localhost:8080/auth/admin/realms/master/users/f6695acb-1418-4ad3-85bb-9aa06025b984"}
  """
  @spec create(map(), String.t()) :: {:ok, map()} | {:error, map()}
  def create(params, admin_access_token) when is_map(params) when is_binary(admin_access_token) do
    url = "#{get_env!(:site)}/admin/realms/#{get_env!(:realm)}/users"

    headers = [
      {"content-type", "application/json"},
      {"Authorization", "Bearer #{admin_access_token}"}
    ]

    body = Jason.encode!(params)

    result =
      :http_client
      |> get_env!()
      |> HTTPClient.request(:post, url, headers, body, [])
      |> handle_response()

    case result do
      {:ok, location} -> {:ok, location}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Gets the user info by the given id

  ## Example
    iex> KeycloakAPI.User.get("f2920937-ab8c-47fd-ac5a-4089707012b4", "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIi...")
    {:ok, %{
      "access" => %{
        "impersonate" => true,
        "manage" => true,
        "manageGroupMembership" => true,
        "mapRoles" => true,
        "view" => true
      },
      "createdTimestamp" => 1_635_967_633_697,
      "disableableCredentialTypes" => [],
      "email" => "test@test.com",
      "emailVerified" => true,
      "enabled" => true,
      "firstName" => "Brandon",
      "id" => "f2920937-ab8c-47fd-ac5a-4089707012b4",
      "lastName" => "Springer",
      "notBefore" => 0,
      "requiredActions" => [],
      "totp" => false,
      "username" => "test@test.com"
    }}
  """
  @spec get(String.t(), String.t()) :: {:ok, map()} | {:error, map()}
  def get(user_id, admin_access_token) when is_binary(user_id) do
    url = "#{get_env!(:site)}/admin/realms/#{get_env!(:realm)}/users/#{user_id}"

    headers = [
      {"content-type", "application/json"},
      {"Authorization", "Bearer #{admin_access_token}"}
    ]

    result =
      :http_client
      |> get_env!()
      |> HTTPClient.request(:get, url, headers, "", [])
      |> handle_response()

    case result do
      {:ok, user} -> {:ok, user}
      {:error, error} -> {:error, error}
    end
  end

  # Gets an env variable
  @spec get_env!(atom()) :: term()
  defp get_env!(key) do
    Application.fetch_env!(:keycloak_api, key) ||
      raise """
      environment variable <#{key}> is missing.
      """
  end

  defp handle_response({:ok, %{status: 201, headers: headers}}) do
    {:ok, get_header(headers, "Location")}
  end

  defp handle_response({:ok, %{status: 200, body: body}}) do
    {:ok, Jason.decode!(body)}
  end

  defp handle_response({:ok, response}) do
    message = """
    unexpected status #{response.status} from Keycloak
    #{response.body}
    """

    {:error, RuntimeError.exception(message)}
  end

  defp handle_response({:error, exception}) do
    {:error, exception}
  end

  @spec get_header([tuple()], binary) :: binary | nil
  defp get_header(headers, key) when is_list(headers) do
    case List.keyfind(headers, key, 0) do
      {_, value} -> value
      _ -> nil
    end
  end
end
