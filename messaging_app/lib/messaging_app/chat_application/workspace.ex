defmodule MessagingApp.ChatApplication.Workspace do
  use Ash.Resource,
    domain: MessagingApp.ChatApplication,
    data_layer: AshPostgres.DataLayer

  alias MessagingApp.ChatApplication.{Channel, Organization, User}

  postgres do
    table "workspaces"
    repo MessagingApp.Repo
  end

  actions do
    defaults [:read]

    create :workspace do
      accept [:name, :organization_id]
    end

    update :update_workspace do
      accept [:name]
    end

    destroy :delete_workspace
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end
  end

  relationships do
    has_many :channels, Channel
    has_many :users, User
    belongs_to :organization, Organization
  end
end
