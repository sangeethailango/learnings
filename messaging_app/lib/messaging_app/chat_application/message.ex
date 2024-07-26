defmodule MessagingApp.ChatApplication.Message do
  use Ash.Resource,
    domain: MessagingApp.ChatApplication,
    data_layer: AshPostgres.DataLayer

  alias MessagingApp.ChatApplication.{Channel, User}

  postgres do
    table "messages"
    repo MessagingApp.Repo
  end

  actions do
    defaults [:read]

    create :message do
      accept [:message, :user_id, :channel_id]
    end

    update :update_message do
      accept [:message]
    end

    destroy :destroy_message
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :message, :string
    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :user, User
    belongs_to :channel, Channel
  end
end
