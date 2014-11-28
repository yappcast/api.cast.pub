defmodule YappCast.EpisodeController do
  use Phoenix.Controller
  alias YappCast.Queries.Episodes

  plug :action

  def show(conn, params) do
    episode = params["id"]
    |> String.to_integer
    |> Episodes.get

    case Canada.Can.can?(conn.assigns.user, :read, episode) do
      true ->
        YappCast.Controllers.send_json(conn, episode)
      false ->
        YappCast.Controllers.send_no_content(conn, 401)        
    end
  end

  def create(conn, params) do
    episode = Episodes.build_episode_from_params(params)

    case Canada.Can.can?(conn.assigns.user, :create, episode) do
      true ->
        case Episodes.create(episode) do
          {:error, errors} ->
            YappCast.Controllers.send_json(conn, errors, 400)
          {:ok, episode} ->
            YappCast.Controllers.send_json(conn, episode)    
        end
      false ->
        YappCast.Controllers.send_no_content(conn, 401)             
    end
  end

  def update(conn, params) do
    episode = params["id"]
    |> String.to_integer
    |> Episodes.get

    case Canada.Can.can?(conn.assigns.user, :update, episode) do
      true ->
        case Episodes.update(episode.id, params) do
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
    episode = params["id"]
    |> String.to_integer
    |> Episodes.get

    case Canada.Can.can?(conn.assigns.user, :delete, episode) do
      true ->
        Episodes.delete(episode.id)
        YappCast.Controllers.send_no_content(conn)    
      false ->
        YappCast.Controllers.send_no_content(conn, 401)            
    end
  end
end
