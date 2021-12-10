# KeycloakAPI

Elixir client to communicate with the [Keycloak](http://www.keycloak.org/) API

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `keycloak_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:keyacloak_api, git: "git@github.com:HeyHomie/keycloak_api.git"}
  ]
end
```
 ## Configuration
 ### Base

 ```elixir
  config :keycloak,
    realm: <REALM>
    site: <KEYCLOAK SERVER URL>
    client_id: <CLIENT_ID>
    client_secret: <CLIENT SECRET>
```

## Verify tokens
You can use [openid_connect](https://hexdocs.pm/openid_connect/readme.html) to verify keycloak tokens:
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
