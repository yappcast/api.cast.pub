defmodule CastPub.PodcastController do
  use Phoenix.Controller
  alias CastPub.Queries.Podcasts

  plug :action

  def index(conn, _params) do
    podcasts = Podcasts.list(conn.assigns.user.id)
    CastPub.Controllers.send_model(conn, podcasts, CastPub.Serializers.Podcasts)
  end

  def show(conn, params) do
    podcast = params["id"]
    |> String.to_integer
    |> Podcasts.get

    case Canada.Can.can?(conn.assigns.user, :read, podcast) do
      true ->
        CastPub.Controllers.send_model(conn, podcast, CastPub.Serializers.Podcast)
      false ->
        CastPub.Controllers.send_no_content(conn, 401)        
    end
  end

  def create(conn, params) do
    {podcast, categories} = Podcasts.build_podcast_from_params(params, conn.assigns.user)
    case Canada.Can.can?(conn.assigns.user, :create, podcast) do
      true ->
        case Podcasts.create(podcast, categories) do
          {:error, errors} ->
            CastPub.Controllers.send_json(conn, errors, 400)
          {:ok, podcast} ->
            CastPub.Controllers.send_model(conn, podcast, CastPub.Serializers.Podcast)    
        end
      false ->
        CastPub.Controllers.send_no_content(conn, 401)             
    end
  end

  def update(conn, params) do
    podcast = params["id"]
    |> String.to_integer
    |> Podcasts.get


    case Canada.Can.can?(conn.assigns.user, :update, podcast) do
      true ->
        case Podcasts.update(podcast.id, params) do
          {:error, errors} ->
            CastPub.Controllers.send_json(conn, errors, 400)
          {:ok, _} ->
            CastPub.Controllers.send_no_content(conn)    
        end
      false ->
        CastPub.Controllers.send_no_content(conn, 401)            
    end
  end

  def destroy(conn, params) do
    podcast = params["id"]
    |> String.to_integer
    |> Podcasts.get


    case Canada.Can.can?(conn.assigns.user, :delete, podcast) do
      true ->
        Podcasts.delete(podcast.id)
        CastPub.Controllers.send_no_content(conn)    
      false ->
        CastPub.Controllers.send_no_content(conn, 401)            
    end
  end


  def rss(conn, params) do
    podcast = params["id"]
    |> String.to_integer
    |> Podcasts.get

    case podcast do
      nil ->
        CastPub.Controllers.send_no_content(conn, 404)
      _ ->
       render conn, "podcast.rss", "rss", podcast: podcast    
    end
  end
end
