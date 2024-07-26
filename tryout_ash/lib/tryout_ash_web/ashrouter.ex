defmodule TryoutAshWeb.Ashrouter do
  use AshJsonApi.Router,
    domains: [Module.concat([TryoutAsh.Hello])],
    open_api: "/application"
end
