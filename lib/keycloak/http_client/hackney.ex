defmodule KeycloakAPI.HTTPClient.Hackney do
  @moduledoc """
  Hackney-based HTTP client adapter.
  ## Options
    * `:default_opts` - default options passed down to Hackney, see `:hackney.request/5` for
      more information.
  """

  @behaviour KeycloakAPI.HTTPClient

  defstruct default_opts: []


  def init(opts) do
    struct!(__MODULE__, opts)
  end

  @impl true
  @spec request(atom(), String.t(), list(), String.t(), Keyword.t()) :: {:ok, map()} | {:error, any()}
  def request(method, url, headers, body, opts) do

    with {:ok, status, headers, body_ref} <- :hackney.request(method, url, headers, body, opts),
         {:ok, body} <- :hackney.body(body_ref) do
      {:ok, %{status: status, headers: headers, body: body}}
    end
  end
end
