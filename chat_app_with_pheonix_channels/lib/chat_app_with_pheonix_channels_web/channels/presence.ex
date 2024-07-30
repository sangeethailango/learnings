defmodule ChatAppWithPheonixChannelsWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :chat_app_with_pheonix_channels,
    pubsub_server: ChatAppWithPheonixChannels.PubSub
end
