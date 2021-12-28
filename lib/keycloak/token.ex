defmodule KeycloakAPI.Token do
  @moduledoc """
  Module to request admin Token to perform admin operations
  """

  alias KeycloakAPI.HTTPClient

  @doc """
  Get admin access token

  ## Example

    iex> Token.get_admin_access_token()
    {:ok,
    %{
      "access_token" => "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIi...",
      "expires_in" => 60,
      "not-before-policy" => 0,
      "refresh_expires_in" => 0,
      "scope" => "profile email",
      "token_type" => "Bearer"
    }}
  """
  @spec get_admin_access_token() :: {:ok, map()} | {:error, map()}
  def get_admin_access_token() do
    params = %{
      grant_type: "client_credentials",
      client_id: get_env!(:client_id),
      client_secret: get_env!(:client_secret)
    }

    url = "#{get_env!(:site)}/realms/master/protocol/openid-connect/token"
    headers = [{"content-type", "application/x-www-form-urlencoded"}]
    body = URI.encode_query(params)

    result =
      :http_client
      |> get_env!()
      |> HTTPClient.request(:post, url, headers, body, [])
      |> handle_response()

    case result do
      {:ok, token} -> {:ok, token}
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

  defp handle_response({:ok, %{status: 200, body: body}}) do
    case Jason.decode(body) do
      {:ok, attrs} -> {:ok, attrs}
      {:error, reason} -> {:error, reason}
    end
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
end
