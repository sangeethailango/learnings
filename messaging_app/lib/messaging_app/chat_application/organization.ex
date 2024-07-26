defmodule MessagingApp.ChatApplication.Organization do
  use Ash.Resource,
    extensions: [AshJsonApi.Resource],
    domain: MessagingApp.ChatApplication,
    data_layer: AshPostgres.DataLayer

  alias MessagingApp.ChatApplication.{User, Workspace}

  postgres do
    table "organizations"
    repo MessagingApp.Repo
  end

  json_api do
    type "organization"
  end

  actions do
    defaults [:read]

    create :organization do
      accept [:name]
    end

    update :update_organization do
      accept [:name]
    end

    destroy :delete_organization
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end
  end

  relationships do
    has_many :workspaces, Workspace
    has_many :users, User
  end
end
