defmodule TdlWeb.Router do
  use TdlWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TdlWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TdlWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/editor/:id", Editor

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/register", UserRegistrationController, :new
    post "/register", UserRegistrationController, :create

    get "/files", FilesController, :index
    get "/files/:id", FilesController, :folder
  end

  # Other scopes may use custom stacks.
  # scope "/api", TdlWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:tdl, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TdlWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
