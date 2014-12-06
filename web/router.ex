defmodule CastPub.Router do
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
    plug PlugJwt, secret: Application.get_env(:cast_pub, :key)
    plug :get_user
  end

  defp get_user(conn, _value) do
    assign conn, :user, CastPub.Queries.Users.get(conn.assigns.claims.user_id)
  end

  scope "/" do
    pipe_through :browser
    get "/", CastPub.PageController, :index, as: :pages
    get "/podcasts/:id/rss", CastPub.PodcastController, :rss
    get "/podcasts/:id/:episode_id/:file_name", CastPub.EpisodeController, :download
  end

  post  "/api/auth",  CastPub.AuthController, :create
  post  "/api/users", CastPub.UserController, :create

  scope "/api" do
    pipe_through :api

    #TODO: Probably just make everything use ids instead of slugs

    get  "/users/current", CastPub.UserController, :show
    patch  "/users/current", CastPub.UserController, :update
    delete "/users/current", CastPub.UserController, :destroy

    post "/podcasts", CastPub.PodcastController, :create
    get "/podcasts/:id", CastPub.PodcastController, :show
    patch "/podcasts/:id", CastPub.PodcastController, :update
    delete "/podcasts/:id", CastPub.PodcastController, :destroy

    post "/podcasts/:id/permissions", CastPub.PodcastPermssionController, :create
    get "/podcasts/:id/permissions", CastPub.PodcastPermssionController, :index
    get "/podcasts/:id/permissions/:permission_id", CastPub.PodcastPermssionController, :show
    patch "/podcasts/:id/permissions/:permission_id", CastPub.PodcastPermssionController, :update
    delete "/podcasts/:id/permissions/:permission_id", CastPub.PodcastPermssionController, :destroy

    post "/episodes", CastPub.EpisodeController, :create
    get "/episodes/:id", CastPub.EpisodeController, :show
    patch "/episodes/:id", CastPub.EpisodeController, :update
    delete "/episodes/:id", CastPub.EpisodeController, :destroy

  end
end
