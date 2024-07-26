defmodule MessagingApp.ChatApplication.Channeluser do
  use Ash.Resource,
    domain: MessagingApp.ChatApplication,
    data_layer: AshPostgres.DataLayer

  alias MessagingApp.ChatApplication.{Channel, User}

  postgres do
    table "channel_users"
    repo MessagingApp.Repo
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  relationships do
    belongs_to :user, User, primary_key?: true, allow_nil?: false
    belongs_to :channel, Channel, primary_key?: true, allow_nil?: false
  end
end
