defmodule ChatAppWithPheonixChannelsWeb.ChatAppLive.Index do
  use ChatAppWithPheonixChannelsWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      <.button phx-click="random-room">Hello</.button>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("random-room", _params, socket) do
    rendom_slug = MnemonicSlugs.generate_slug()

    {
      :noreply,
      socket
      |> push_navigate(to: "/#{rendom_slug}")
    }
  end
end
