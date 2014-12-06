defmodule CastPub.Queries.Podcasts.SubCategories do
  import Ecto.Query
  alias CastPub.Models.Podcast.SubCategory
  alias CastPub.Repo

  def list(podcast_category_id) do
    query = from u in SubCategory, 
            where: u.podcast_category_id == ^podcast_category_id, 
            select: u
    Repo.all(query)
  end

  def create(podcast_sub_category) do
    CastPub.Queries.create(podcast_sub_category)
  end

  def delete(id) do
    Repo.get(SubCategory, id)
    |> Repo.delete
  end


end