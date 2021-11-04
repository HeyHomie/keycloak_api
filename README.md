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
