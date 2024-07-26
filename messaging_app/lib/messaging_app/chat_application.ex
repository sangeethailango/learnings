defmodule MessagingApp.ChatApplication do
  use Ash.Domain, extensions: [AshJsonApi.Domain]

  alias MessagingApp.ChatApplication.{
    Channel,
    Message,
    Organization,
    Workspace,
    User,
    Channeluser
  }

  resources do
    resource Channel
    resource Message
    resource Organization
    resource Workspace
    resource User
    resource Channeluser
  end

  json_api do
    routes do
      # in the domain `base_route` acts like a scope
      base_route "/organizations", Organization do
        get(:read)
        post(:organization)
        index :read
      end
    end
  end
end
