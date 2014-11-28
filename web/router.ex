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
    plug :get_user
  end

  defp get_user(conn, _value) do
    assign conn, :user, YappCast.Queries.Users.get(conn.assigns.claims.user_id)
  end

  scope "/" do
    pipe_through :browser
    get "/", YappCast.PageController, :index, as: :pages
    get "/podcasts/:podcast_id/rss", YappCast.PodcastController, :rss
    get "/podcasts/:podcast_id/:episode_id/:file_name", YappCast.EpisodeController, :download
  end

  post  "/api/auth",  YappCast.AuthController, :create
  post  "/api/users", YappCast.UserController, :create

  scope "/api" do
    pipe_through :api

    #TODO: Probably just make everything use ids instead of slugs

    get  "/users/current", YappCast.UserController, :show
    patch  "/users/current", YappCast.UserController, :update
    delete "/users/current", YappCast.UserController, :destroy

    post "/podcasts", YappCast.PodcastController, :create
    get "/podcasts/:id", YappCast.PodcastController, :show
    patch "/podcasts/:id", YappCast.PodcastController, :update
    delete "/podcasts/:id", YappCast.PodcastController, :destroy

    post "/podcasts/:id/permissions", YappCast.PodcastPermssionController, :create
    get "/podcasts/:id/permissions", YappCast.PodcastPermssionController, :index
    get "/podcasts/:id/permissions/:permission_id", YappCast.PodcastPermssionController, :show
    patch "/podcasts/:id/permissions/:permission_id", YappCast.PodcastPermssionController, :update
    delete "/podcasts/:id/permissions/:permission_id", YappCast.PodcastPermssionController, :destroy

    post "/episodes", YappCast.EpisodeController, :create
    get "/episodes/:id", YappCast.EpisodeController, :show
    patch "/episodes/:id", YappCast.EpisodeController, :update
    delete "/episodes/:id", YappCast.EpisodeController, :destroy

  end
end
