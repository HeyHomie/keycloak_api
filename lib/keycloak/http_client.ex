defmodule KeycloakAPI.HTTPClient do
  @moduledoc """
  HTTP Client
  """

  @doc """
  Creates a new user
  """
  @spec create_user(map()) :: {:ok, Tesla.Env.t()} | {:error, map()}
  def create_user(user_params) do
    with {:ok, %{"access_token" => access_token}} <- get_admin_access_token() do
      client = build_client(access_token)
      realm = get_env!(:realm)
      Tesla.post(client, "/admin/realms/#{realm}/users", user_params)
    end
  end

  @doc """
  Get user info by the given id
  """
  @spec get_user(String.t()) :: {:ok, map()} | {:error, map()}
  def get_user(user_id) do
    with {:ok, %{"access_token" => access_token}} <- get_admin_access_token() do
      client = build_client(access_token)
      realm = get_env!(:realm)

      Tesla.get(client, "/admin/realms/#{realm}/users/#{user_id}")
    end
  end

  # Get admin access token
  @spec get_admin_access_token() :: {:ok, map()} | {:error, map()}
  defp get_admin_access_token() do
    middleware = [
      {Tesla.Middleware.BaseUrl, get_env!(:site)},
      Tesla.Middleware.JSON,
      Tesla.Middleware.FormUrlencoded
    ]

    client = Tesla.client(middleware)

    params = %{
      grant_type: "client_credentials",
      client_id: get_env!(:client_id),
      client_secret: get_env!(:client_secret)
    }

    case Tesla.post(client, "/realms/master/protocol/openid-connect/token", params) do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %Tesla.Env{status: _status, body: body}} ->
        {:error, body}
    end
  end

  # Builds a new client
  @spec build_client(String.t()) :: {:ok, map()} | {:error, map()}
  defp build_client(access_token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, get_env!(:site)},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer #{access_token}"}]}
    ]

    Tesla.client(middleware)
  end

  # Gets an env variable
  @spec get_env!(atom()) :: term()
  defp get_env!(key) do
    Application.fetch_env!(:keycloak_api, key)
  end
end
