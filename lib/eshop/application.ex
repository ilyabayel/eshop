defmodule Eshop.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EshopWeb.Telemetry,
      Eshop.Repo,
      {DNSCluster, query: Application.get_env(:eshop, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Eshop.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Eshop.Finch},
      # Start a worker by calling: Eshop.Worker.start_link(arg)
      # {Eshop.Worker, arg},
      # Start to serve requests, typically the last entry
      EshopWeb.Endpoint,
      TwMerge.Cache
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Eshop.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EshopWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
