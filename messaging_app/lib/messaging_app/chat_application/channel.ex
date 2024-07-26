defmodule MessagingApp.ChatApplication.Channel do
  use Ash.Resource,
    domain: MessagingApp.ChatApplication,
    data_layer: AshPostgres.DataLayer

  alias MessagingApp.ChatApplication.{Channeluser, User, Workspace}

  postgres do
    table "channels"
    repo MessagingApp.Repo
  end

  actions do
    defaults [:read]

    create :channel do
      accept [:name, :description, :is_public]
    end

    update :update do
      accept [:name, :description, :is_public]
    end

    destroy :destroy_channel
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    attribute :description, :string

    attribute :is_public, :boolean

    create_timestamp :inserted_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :workspace, Workspace

    many_to_many :users, User do
      through Channeluser
    end
  end
end
