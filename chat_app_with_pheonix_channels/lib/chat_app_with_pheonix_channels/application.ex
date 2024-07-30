defmodule ChatAppWithPheonixChannels.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ChatAppWithPheonixChannelsWeb.Telemetry,
      {DNSCluster,
       query: Application.get_env(:chat_app_with_pheonix_channels, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ChatAppWithPheonixChannels.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ChatAppWithPheonixChannels.Finch},
      # Start a worker by calling: ChatAppWithPheonixChannels.Worker.start_link(arg)
      # {ChatAppWithPheonixChannels.Worker, arg},
      # Start to serve requests, typically the last entry
      ChatAppWithPheonixChannelsWeb.Endpoint,
      ChatAppWithPheonixChannelsWeb.Presence
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ChatAppWithPheonixChannels.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ChatAppWithPheonixChannelsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
