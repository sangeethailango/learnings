defmodule TryoutAsh.Hello.User do
  use Ash.Resource,
    domain: TryoutAsh.Hello,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  postgres do
    table "users"
    repo TryoutAsh.Repo
  end

  json_api do
    type "user"
  end

  actions do
    # defaults [:read]

    read :read

    create :user do
      accept [:name, :age]
    end

    update :update do
      accept [:name]
    end

    destroy :destroy
  end

  attributes do
    uuid_primary_key :id
    attribute :name, :string
    attribute :age, :integer
  end
end
