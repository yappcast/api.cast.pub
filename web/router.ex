defmodule CastPub.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ~w(html)
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
  post  "/api/user", CastPub.UserController, :create

  scope "/api" do
    pipe_through :api

    get  "/user", CastPub.UserController, :show
    patch  "/user", CastPub.UserController, :update
    delete "/user", CastPub.UserController, :destroy

    get "/podcasts", CastPub.PodcastController, :index
    post "/podcasts", CastPub.PodcastController, :create
    get "/podcasts/:id", CastPub.PodcastController, :show
    patch "/podcasts/:id", CastPub.PodcastController, :update
    delete "/podcasts/:id", CastPub.PodcastController, :destroy

    get "/permissions", CastPub.PodcastPermssionController, :index
    post "/permissions", CastPub.PodcastPermssionController, :create
    get "/permissions/:id", CastPub.PodcastPermssionController, :show
    patch "/permissions/:id", CastPub.PodcastPermssionController, :update
    delete "/permissions/:id", CastPub.PodcastPermssionController, :destroy

    post "/episodes", CastPub.EpisodeController, :create
    get "/episodes/:id", CastPub.EpisodeController, :show
    patch "/episodes/:id", CastPub.EpisodeController, :update
    delete "/episodes/:id", CastPub.EpisodeController, :destroy

  end
end
