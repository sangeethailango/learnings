defmodule MessagingAppWeb.Router do
  use MessagingAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MessagingAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # forward "/api/swaggerui",
  #         OpenApiSpex.Plug.SwaggerUI,
  #         path: "/api/open_api",
  #         default_model_expand_depth: 4

  scope "/", MessagingAppWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  forward "/api/swaggerui",
          OpenApiSpex.Plug.SwaggerUI,
          path: "/api/open_api",
          default_model_expand_depth: 4

  forward "/api", MessagingAppWeb.JsonApiRouter

  # scope "/api/json" do
  #   pipe_through(:api)

  #   forward "/messaging_app", MessagingAppWeb.JsonApiRouter
  # end

  # Other scopes may use custom stacks.
  # scope "/api", MessagingAppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:messaging_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MessagingAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
