# KeycloakAPI

Elixir client to communicate with the [Keycloak](http://www.keycloak.org/) API

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `keycloak_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:keyacloak_api, git: "https://github.com/elixir-lang/gettext.git", tag: "0.1"}
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
