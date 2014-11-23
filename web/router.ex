defmodule YappCast.Router do
  use Phoenix.Router

  pipeline :before do
    plug :super
    plug PlugCors, headers: ["Authorization", "Content-Type"]
  end

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
  end

  pipeline :api do
    plug :accepts, ~w(json)
    plug PlugJwt, secret: Application.get_env(:yapp_cast, :key)
  end

  scope "/" do
    pipe_through :browser
    get "/", YappCast.PageController, :index, as: :pages
  end

  post  "/api/auth",  YappCast.AuthController, :create
  post  "/api/users", YappCast.UserController, :create

  scope "/api" do
    pipe_through :api

    get  "/users/current", YappCast.UserController, :current
    patch  "/users/current", YappCast.UserController, :update
    delete "/users/current", YappCast.UserController, :destroy

    post "/companies", YappCast.CompanyController, :create
    get "/companies", YappCast.CompanyController, :index
    get "/companies/:slug", YappCast.CompanyController, :show
    patch "/companies/:slug", YappCast.CompanyController, :update
    delete "/companies/:slug", YappCast.CompanyController, :destroy

    post "/companies/:slug/permissions", YappCast.CompanyPermissionController, :create
    get "/companies/:slug/permissions", YappCast.CompanyPermissionController, :index
    get "/companies/:slug/permissions/:id", YappCast.CompanyPermissionController, :show
    patch "/companies/:slug/permissions/:id", YappCast.CompanyPermissionController, :update
    delete "/companies/:slug/permissions/:id", YappCast.CompanyPermissionController, :destroy

    post "/podcasts", YappCast.PodcastController, :create
    get "/podcasts", YappCast.PodcastController, :index
    get "/podcasts/:slug", YappCast.PodcastController, :show
    get "/podcasts/:slug/rss", YappCast.PodcastController, :rss
    patch "/podcasts/:slug", YappCast.PodcastController, :update
    delete "/podcasts/:slug", YappCast.PodcastController, :destroy

    post "/podcasts/:slug/permissions", YappCast.PodcastPermssionController, :create
    get "/podcasts/:slug/permissions", YappCast.PodcastPermssionController, :index
    get "/podcasts/:slug/permissions/:id", YappCast.PodcastPermssionController, :show
    patch "/podcasts/:slug/permissions/:id", YappCast.PodcastPermssionController, :update
    delete "/podcasts/:slug/permissions/:id", YappCast.PodcastPermssionController, :destroy

    post "/episodes", YappCast.EpisodeController, :create
    get "/episodes", YappCast.EpisodeController, :index
    get "/episodes/:slug", YappCast.EpisodeController, :show
    get "/episodes/:slug/:file_name", YappCast.EpisodeController, :download
    patch "/episodes/:slug", YappCast.EpisodeController, :update
    delete "/episodes/:slug", YappCast.EpisodeController, :destroy

  end
end
