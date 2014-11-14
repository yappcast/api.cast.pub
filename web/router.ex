defmodule YappCast.Router do
  use Phoenix.Router

  pipeline :before do
    plug :super
    plug PlugCors, headers: ["Authorization", "Content-Type"]
  end

  scope "/" do
    # Use the default browser stack.
    pipe_through :browser

    get "/", YappCast.PageController, :index, as: :pages
  end

  post  "/api/auth",  YappCast.AuthController, :create
  post  "/api/users", YappCast.UserController, :create

  pipeline :secure do
    plug PlugJwt, secret: Application.get_env(:yapp_cast, :secret)
  end

  # Other scopes may use custom stacks.
  scope "/api" do
    pipe_through [:api, :secure]

    patch  "/users/:id", YappCast.UserController, :update
    delete "/users/:id", YappCast.UserController, :destroy
    resources "/companies", YappCast.CompanyController do
      resources "/permissions", YappCast.CompanyPermissionController
      resources "/podcasts", YappCast.PodcastController do
        resources "/permissions", YappCast.PodcastPermissionController
        resources "/episodes", YappCast.EpisodeController
      end
    end
  end
end
