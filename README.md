# KeycloakAPI

Elixir client to communicate with the [Keycloak](http://www.keycloak.org/) API

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `keycloak_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    # Hackney is the default HTTP library
    {:hackney, "~> 1.17"},
    {:keycloak_api, git: "git@github.com:HeyHomie/keycloak_api.git"}
  ]
end
```
 ## Configuration
 ### Base

 ```elixir
  config :keycloak_api,
    realm: "<REALM>"
    site: "<KEYCLOAK_SERVER_URL>"
    client_id: "<CLIENT_ID>"
    client_secret: "<CLIENT_SECRET>",
    http_client: KeycloakAPI.HTTPClient.Hackney
```

## Usage

### Create user

```elixir
  # Build the user params
  iex> params = %{
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

  # Get an admin access token
  iex> {:ok, %{"access_token" => keycloak_token}} <-
             KeycloakAPI.Token.get_admin_access_token()

  # Perform the request
  # Keycloak return the data in the Location header. This value is returned
  iex> KeycloakAPI.User.create(params, keycloak_token)
  {:ok,
    "http://localhost:8080/auth/admin/realms/master/users/f6695acb-1418-4ad3-85bb-9aa06025b984"}
```


## Verify tokens
You can use [openid_connect](https://hexdocs.pm/openid_connect/readme.html) to verify keycloak (or other providers) tokens:
```elixir
      config :my_app, :openid_connect_providers,
        keycloak: [
          discovery_document_uri: http://localhost:8080/auth/realms/<REALM>/.well-known/openid-configuration,
          client_id: <CLIENT_ID>,
          client_secret: <CLIENT SECRET>,
          redirect_uri: "https://localhost:4000/auth/callback",
          response_type: "code",
          scope: "openid email profile"
        ]
```
