defmodule StakeLaneApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      StakeLaneApi.Repo,
      # Start the Telemetry supervisor
      StakeLaneApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: StakeLaneApi.PubSub},
      # Start the Endpoint (http/https)
      StakeLaneApiWeb.Endpoint,
      # Start a worker by calling: StakeLaneApi.Worker.start_link(arg)
      # {StakeLaneApi.Worker, arg}
      {Oban, oban_config()},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StakeLaneApi.Supervisor]
    Supervisor.start_link(children, opts)
    |> after_start
  end

  defp after_start({:ok, _} = result) do
    Geolix.load_database(%{
      id:      :city,
      adapter: Geolix.Adapter.MMDB2,
      source:  Application.app_dir(:stake_lane_api, "priv") |> Path.join("data/city20200929.mmdb")
    })
    result
  end
  defp after_start(result), do: result

  # Conditionally disable crontab, queues, or plugins here.
  defp oban_config do
    Application.get_env(:stake_lane_api, Oban)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    StakeLaneApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
