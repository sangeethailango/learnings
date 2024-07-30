defmodule ChatAppWithPheonixChannelsWeb.ChatAppLive.RandomRoom do
  use ChatAppWithPheonixChannelsWeb, :live_view

  def render(assigns) do
    ~H"""
    currently chatting in <strong><%= @room %></strong>
    as <strong><%= @username %></strong>
    <div id="chat-container">
      <div id="chat-messages" phx-update="append">
        <%= for message <- @messages do %>
          <%= display_messages(message) %>
        <% end %>
      </div>

      <.simple_form :let={form} for={%{}} phx-submit="message-submit" phx-change="validate">
        <.input type="text" field={form[:message]} value={@message} placeholder="Enter your message" />
      </.simple_form>
    </div>
    <div>
      <%= for user <- @userlist do %>
        <p><%= user %></p>
      <% end %>
    </div>
    """
  end

  def mount(params, _session, socket) do
    topic = "topic #{params["id"]}"
    username = MnemonicSlugs.generate_slug()

    if connected?(socket) do
      ChatAppWithPheonixChannelsWeb.Endpoint.subscribe(topic)
      ChatAppWithPheonixChannelsWeb.Presence.track(self(), topic, username, %{})
    end

    {:ok,
     socket
     |> assign(:room, params["id"])
     |> assign(messages: [])
     |> assign(:topic, topic)
     |> assign(:message, "")
     |> assign(:userlist, [])
     |> assign(:username, username)}
  end

  def handle_info(%{event: "presence_diff", payload: %{joins: joins, leaves: leaves}}, socket) do
    join_messages =
      joins
      |> Map.keys()
      |> Enum.map(fn username ->
        %{type: :system, id: UUID.uuid4(), message: "#{username} Joined the chat "}
      end)

    leave_messages =
      leaves
      |> Map.keys()
      |> Enum.map(fn username ->
        %{type: :system, id: UUID.uuid4(), message: "#{username} Left the chat"}
      end)

    userlist =
      ChatAppWithPheonixChannelsWeb.Presence.list(socket.assigns.topic)
      |> Map.keys()

    {:noreply,
     socket
     |> assign(messages: join_messages ++ leave_messages)
     |> assign(userlist: userlist)}
  end

  def handle_event("validate", params, socket) do
    {:noreply,
     socket
     |> assign(:message, params["message"])}
  end

  def handle_event("message-submit", params, socket) do
    content = %{message: params["message"], username: socket.assigns.username}

    ChatAppWithPheonixChannelsWeb.Endpoint.broadcast(
      socket.assigns.topic,
      "new-message",
      content
    )

    {:noreply, socket |> assign(:message, "")}
  end

  def handle_info(%{event: "new-message", payload: content}, socket) do
    {:noreply,
     socket
     |> assign(:messages, [
       %{id: UUID.uuid4(), message: content.message, username: content.username}
     ])}
  end

  def display_messages(%{id: id, message: message, type: :system}) do
    Phoenix.HTML.raw("<p id=#{id}><b>System:</b><em> #{message}</em></p>")
  end

  def display_messages(%{id: id, message: message, username: username}) do
    Phoenix.HTML.raw("<p id=#{id}><strong>#{username}:</strong> #{message}</p>")
  end
end
