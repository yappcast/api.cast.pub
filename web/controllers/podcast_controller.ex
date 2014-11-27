defmodule YappCast.PodcastController do
  use Phoenix.Controller
  alias YappCast.Queries.Podcasts
  alias YappCast.Models.Podcast
  alias YappCast.Queries.Users

  plug :action

  def show(conn, params) do
    podcast = Podcasts.get_by_slug(params["slug"])

    case Canada.Can.can?(conn.assigns.user, :read, podcast) do
      true ->
        YappCast.Controllers.send_json(conn, podcast)
      false ->
        YappCast.Controllers.send_no_content(conn, 401)        
    end
  end

  def rss(conn, _params) do
    render conn, "index"
  end

  def create(conn, params) do
    podcast = Podcasts.build_podcast_from_params(params, conn.assigns.user)

    case Canada.Can.can?(conn.assigns.user, :create, podcast) do
      true ->
        case Podcasts.create(podcast) do
          {:error, errors} ->
            YappCast.Controllers.send_json(conn, errors, 400)
          {:ok, company} ->
            YappCast.Controllers.send_json(conn, company)    
        end
      false ->
        YappCast.Controllers.send_no_content(conn, 401)             
    end
  end

  def update(conn, params) do
    podcast = Podcasts.get_by_slug(params["slug"])

    case Canada.Can.can?(conn.assigns.user, :update, podcast) do
      true ->
        case Podcasts.update(podcast.id, params) do
          {:error, errors} ->
            YappCast.Controllers.send_json(conn, errors, 400)
          {:ok, _} ->
            YappCast.Controllers.send_no_content(conn)    
        end
      false ->
        YappCast.Controllers.send_no_content(conn, 401)            
    end
  end

  def destroy(conn, params) do
    podcast = Podcasts.get_by_slug(params["slug"])

    case Canada.Can.can?(conn.assigns.user, :delete, podcast) do
      true ->
        Podcasts.delete(podcast.id)
        YappCast.Controllers.send_no_content(conn)    
      false ->
        YappCast.Controllers.send_no_content(conn, 401)            
    end
  end
end
