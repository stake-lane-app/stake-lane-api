defmodule BolaoHubApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      BolaoHubApi.Repo,
      # Start the Telemetry supervisor
      BolaoHubApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: BolaoHubApi.PubSub},
      # Start the Endpoint (http/https)
      BolaoHubApiWeb.Endpoint
      # Start a worker by calling: BolaoHubApi.Worker.start_link(arg)
      # {BolaoHubApi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BolaoHubApi.Supervisor]
    Supervisor.start_link(children, opts)
    |> after_start
  end

  defp after_start({:ok, _} = result) do
    Geolix.load_database(%{
      id:      :city,
      adapter: Geolix.Adapter.MMDB2,
      source:  Application.app_dir(:bolao_hub_api, "priv") |> Path.join("data/city20200929.mmdb")
    })
    result
  end
  defp after_start(result), do: result

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BolaoHubApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
