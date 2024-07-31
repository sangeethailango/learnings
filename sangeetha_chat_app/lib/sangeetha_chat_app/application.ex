defmodule SangeethaChatApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SangeethaChatAppWeb.Telemetry,
      SangeethaChatApp.Repo,
      {DNSCluster, query: Application.get_env(:sangeetha_chat_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SangeethaChatApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SangeethaChatApp.Finch},
      # Start a worker by calling: SangeethaChatApp.Worker.start_link(arg)
      # {SangeethaChatApp.Worker, arg},
      # Start to serve requests, typically the last entry
      SangeethaChatAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SangeethaChatApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SangeethaChatAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
