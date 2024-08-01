defmodule SangeethaChatAppWeb.ChatLive.ChatRoom do
  use SangeethaChatAppWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      You are chatting in <b><%= @chat_room %></b>
      <p>You are joined as <b><%= @username %></b></p>
      <div class="border-2 h-[500px]" id="id" phx-update="stream">
        <%= for message <- @messages do %>
          <p class="py-1 ml-2">
            <%= @message_username %>:<%= message %>
          </p>
        <% end %>
      </div>
      <.simple_form :let={form} for={%{}} phx-validaet="validate" phx-submit="message-submit">
        <.input field={form[:message]} value={@message} type="text" />
      </.simple_form>
      <%= for user <- @userlist do %>
        <p><%= user %></p>
      <% end %>
    </div>
    """
  end

  def mount(params, _session, socket) do
    topic = params["chat_room"]

    username = MnemonicSlugs.generate_slug(2)

    if connected?(socket) do
      SangeethaChatAppWeb.Endpoint.subscribe(topic)
      SangeethaChatAppWeb.Presence.track(self(), topic, username, %{})
    end

    {:ok,
     socket
     |> assign(:chat_room, params["chat_room"])
     |> assign(:messages, [])
     |> assign(:username, username)
     |> assign(:message_username, "system")
     |> assign(:userlist, [])
     |> assign(:message, "")
     |> assign(:topic, topic)}
  end

  def handle_event("validate", params, socket) do
    {:noreply,
     socket
     |> assign(:message, params["message"])}
  end

  def handle_info(
        %{event: "presence_diff", payload: %{joins: joins, leaves: leaves}},
        socket
      ) do
    joined_users =
      Map.keys(joins)
      |> Enum.map(fn user -> "#{user} Joined the chat" end)

    left_users =
      Map.keys(leaves)
      |> Enum.map(fn user ->
        "#{user} Left the chat"
      end)

    userlist =
      SangeethaChatAppWeb.Presence.list(socket.assigns.topic)
      |> Map.keys()

    {:noreply,
     socket
     |> assign(:messages, [joined_users ++ left_users])
     |> assign(:message_username, "system")
     |> assign(:userlist, userlist)}
  end

  def handle_event("message-submit", params, socket) do
    new_message = %{username: socket.assigns.username, content: params["message"]}

    SangeethaChatAppWeb.Endpoint.broadcast!(
      socket.assigns.topic,
      "new-message",
      new_message
    )

    {:noreply, socket}
  end

  def handle_info(%{event: "new-message", payload: new_message}, socket) do
    {:noreply,
     socket
     |> assign(:messages, [new_message.content])
     |> assign(:message, "")
     |> assign(:message_username, new_message.username)}
  end
end
