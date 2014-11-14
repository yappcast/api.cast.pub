defmodule YappCast.Router do
  use Phoenix.Router

  scope "/" do
    # Use the default browser stack.
    pipe_through :browser

    get "/", YappCast.PageController, :index, as: :pages
  end

  post  "/api/users", UserController, :create
  post  "/api/auth",  AuthController, :create

  pipeline :api do
    plug PlugJwt, secret: "secret"
  end

  # Other scopes may use custom stacks.
  scope "/api" do
    pipe_through :api

    patch  "users/:id", UserController, :update
    delete "users/:id", UserController, :destroy
    resources "/companies", CompanyController do
      resources "/permissions", CompanyPermissionController
      resources "/podcasts", PodcastController do
        resources "/permissions", PodcastPermissionController
        resources "/episodes", EpisodeController
      end
    end
  end
end
