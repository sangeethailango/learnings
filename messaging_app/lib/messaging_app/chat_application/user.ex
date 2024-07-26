defmodule MessagingApp.ChatApplication.User do
  use Ash.Resource,
    extensions: [AshJsonApi.Resource],
    domain: MessagingApp.ChatApplication,
    data_layer: AshPostgres.DataLayer

  alias MessagingApp.ChatApplication.{Organization, Workspace}

  postgres do
    table "users"
    repo MessagingApp.Repo
  end

  json_api do
    type "user"
  end

  actions do
    defaults [:read]

    create :user do
      accept [:name, :workspace_id, :organization_id]
    end

    update :update_user do
      accept [:name, :workspace_id, :organization_id]
    end
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end
  end

  relationships do
    belongs_to :workspace, Workspace
    belongs_to :organization, Organization
  end
end
