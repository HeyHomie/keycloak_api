defmodule KeycloakAPI do
  @moduledoc """
  Documentation for `KeycloakAPI`.
  """
  require Logger

  alias KeycloakAPI.HTTPClient

  @doc """
  Creates a new user in Keycloak
  """
  @spec create_user(map()) :: {:ok, map()} | {:error, map()}
  def create_user(params) do
    case HTTPClient.create_user(params) do
      {:ok, %Tesla.Env{status: 201} = env} ->
        {:ok, %{user_loaction: Tesla.get_header(env, "Location")}}

      {:ok, %Tesla.Env{status: status, body: body}} ->
        Logger.debug(fn ->
          "Faild attempt to create user with status: #{status} & response #{body}"
        end)

        {:error, body}
    end
  end

  @doc """
  Gets the user info by the given id
  """
  @spec get_user(String.t()) :: {:ok, map()} | {:error, map()}
  def get_user(user_id) when is_binary(user_id) do
    case HTTPClient.get_user(user_id) do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %Tesla.Env{status: status, body: body}} ->
        Logger.debug(fn ->
          "Faild attempt to get user info with status: #{status} & response #{body}"
        end)

        {:error, body}
    end
  end
end
