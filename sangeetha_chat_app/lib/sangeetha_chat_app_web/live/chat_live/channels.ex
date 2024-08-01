defmodule SangeethaChatAppWeb.ChatLive.Channels do
  use SangeethaChatAppWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      <.button phx-click="chat_room">Talam</.button>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("chat_room", _params, socket) do
    chat_room = MnemonicSlugs.generate_slug(2)

    {:noreply,
     socket
     |> push_navigate(to: "/#{chat_room}")}
  end
end
