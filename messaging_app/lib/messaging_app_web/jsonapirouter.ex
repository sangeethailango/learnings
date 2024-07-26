defmodule MessagingAppWeb.JsonApiRouter do
  use AshJsonApi.Router,
    # The api modules you want to serve
    domains: [Module.concat(["MessagingApp.ChatApplication"])],
    # optionally an open_api route
    open_api: "/open_api"
end
