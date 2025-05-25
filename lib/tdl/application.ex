defmodule Tdl.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Tdl.File, name: Tdl.File},
      TdlWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:tdl, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Tdl.PubSub},
      # Start a worker by calling: Tdl.Worker.start_link(arg)
      # {Tdl.Worker, arg},
      # Start to serve requests, typically the last entry
      TdlWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tdl.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TdlWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
