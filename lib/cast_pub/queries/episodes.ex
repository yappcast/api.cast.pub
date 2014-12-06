defmodule CastPub.Queries.Episodes do
  import Ecto.Query
  alias CastPub.Models.Episode
  alias CastPub.Repo

  def get(id) do
    Repo.get(Episode, id)
  end

  def list(podcast_id) do
    query = from u in Episode,
          where: u.podcast_id == ^podcast_id,
         select: u

    Repo.all(query)
  end

  def build_episode_from_params(params) do
    %Episode{
      title: Dict.get(params, "title"),
      publish_date: Dict.get(params, "publish_date"),
      author: Dict.get(params, "author"),
      block: Dict.get(params, "block", false),
      image_url: Dict.get(params, "image_url"),
      duration: Dict.get(params, "duration"),
      explicit: Dict.get(params, "explicit", false),
      is_closed_captioned: Dict.get(params, "is_closed_captioned", false),
      order: Dict.get(params, "order"),
      subtitle: Dict.get(params, "subtitle"),
      summary: Dict.get(params, "summary"),
      media_url: Dict.get(params, "media_url"),
      podcast_id: Dict.get(params, "podcast_id")
    }
  end

  def create(episode) do
    CastPub.Queries.create(episode)
  end

  def update(id, data) do
    case get(id) do
      nil ->
        {:error, [{:error, :episode, :episode, "episode not found"}]}
      updating_episode ->
        
        updating_episode
        |> CastPub.Queries.update_map_with_params(data, [
            :title, :publish_date, 
            :author, :block, :image_url, :duration, 
            :explicit, :is_closed_captioned, :order, 
            :subtitle, :summary, :media_url
          ])
        |> CastPub.Queries.update
    end
  end

  def delete(id) do
    Repo.get(Episode, id)
    |> Repo.delete
  end
end