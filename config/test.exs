import Config

config :keycloak_api,
  realm: "master",
  site: "http://localhost:8080/auth",
  client_id: "some-id",
  client_secret: "very-secret"
