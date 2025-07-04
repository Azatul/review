defmodule Review.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ReviewWeb.Telemetry,
      Review.Repo,
      {DNSCluster, query: Application.get_env(:review, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Review.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Review.Finch},
      # Start a worker by calling: Review.Worker.start_link(arg)
      # {Review.Worker, arg},
      # Start to serve requests, typically the last entry
      ReviewWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Review.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ReviewWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
