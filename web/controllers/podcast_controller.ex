defmodule YappCast.PodcastController do
  use Phoenix.Controller
  alias YappCast.Queries.Podcasts

  plug :action

  def show(conn, params) do
    podcast = params["id"]
    |> String.to_integer
    |> Podcasts.get

    case Canada.Can.can?(conn.assigns.user, :read, podcast) do
      true ->
        YappCast.Controllers.send_json(conn, podcast)
      false ->
        YappCast.Controllers.send_no_content(conn, 401)        
    end
  end

  def create(conn, params) do
    podcast = Podcasts.build_podcast_from_params(params, conn.assigns.user)

    case Canada.Can.can?(conn.assigns.user, :create, podcast) do
      true ->
        case Podcasts.create(podcast) do
          {:error, errors} ->
            YappCast.Controllers.send_json(conn, errors, 400)
          {:ok, podcast} ->
            YappCast.Controllers.send_json(conn, podcast)    
        end
      false ->
        YappCast.Controllers.send_no_content(conn, 401)             
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
            YappCast.Controllers.send_json(conn, errors, 400)
          {:ok, _} ->
            YappCast.Controllers.send_no_content(conn)    
        end
      false ->
        YappCast.Controllers.send_no_content(conn, 401)            
    end
  end

  def destroy(conn, params) do
    podcast = params["id"]
    |> String.to_integer
    |> Podcasts.get


    case Canada.Can.can?(conn.assigns.user, :delete, podcast) do
      true ->
        Podcasts.delete(podcast.id)
        YappCast.Controllers.send_no_content(conn)    
      false ->
        YappCast.Controllers.send_no_content(conn, 401)            
    end
  end
end
