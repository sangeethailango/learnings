defmodule TryoutAsh.Hello do
  use Ash.Domain,
    extensions: [AshJsonApi.Domain]

  alias TryoutAsh.Hello.User

  resources do
    resource User
  end

  json_api do
    routes do
      base_route("/users", User) do
        get(:read)
        post(:user)
        index :read
        patch(:update)
        delete(:destroy)
      end
    end
  end
end
