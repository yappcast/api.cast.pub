defmodule YappCast.Queries.Podcasts.Categories do
  import Ecto.Query
  alias YappCast.Models.Podcast.Category
  alias YappCast.Repo

  def list(podcast_id) do
    query = from u in Category, 
            where: u.podcast_id == ^podcast_id, 
            select: u, 
            preload: :sub_categories
    Repo.all(query)
  end

  def create(podcast_category) do
    YappCast.Queries.create(podcast_category)
  end

  def delete(id) do
    Repo.get(Category, id)
    |> Repo.delete
  end
end