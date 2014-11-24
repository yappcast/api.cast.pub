defmodule YappCast.Queries.Episodes do
  import Ecto.Query
  alias YappCast.Models.Episode
  alias YappCast.Repo

  def get(id) do
    Repo.get(Episode, id)
  end

  def get_by_slug(slug) do
    query = from u in Episode,
          where: u.slug == ^slug,
         select: u

    Repo.one(query)
  end

  def list(podcast_id) do
    query = from u in Episode,
          where: u.podcast_id == ^podcast_id,
         select: u

    Repo.all(query)
  end

  def create(episode) do
    YappCast.Queries.create(episode)
  end

  def update(id, data) do
    case get(id) do
      nil ->
        {:error, [{:error, :episode, :episode, "episode not found"}]}
      updating_episode ->
        
        updating_episode
        |> YappCast.Queries.update_map_with_params(data, [
            :title, :publish_date, 
            :author, :block, :image_url, :duration, 
            :explicit, :is_closed_captioned, :order, 
            :subtitle, :summary, :slug, :media_url
          ])
        |> YappCast.Queries.update
    end
  end

  def delete(id) do
    Repo.get(Episode, id)
    |> Repo.delete
  end
end