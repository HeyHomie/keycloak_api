defmodule KeycloakAPI.HTTPClient do
  @moduledoc """
  Specification for a KeycloakAPI HTTP client.
  The client is configured as a `{module, initial_state}` tuple where the module
  implements this behaviour and `initial_state` is returned by the `c:init/1`
  callback.
  The `c:init/1` callback gives an opportunity to perform some initialization tasks just once.
  """

  @type method() :: atom()

  @type url() :: binary()

  @type status() :: non_neg_integer()

  @type header() :: {binary(), binary()}

  @type body() :: binary()

  @type initial_state() :: map()

  @doc """
  Callback to make an HTTP request.
  """
  @callback request(method(), url(), [header()], body(), opts :: keyword()) ::
              {:ok, %{status: status, headers: [header()], body: body()}}
              | {:error, Exception.t()}

  @doc false
  def request(module, method, url, headers, body, opts) do
    module.request(method, url, headers, body, opts)
  end
end
