defmodule CastPub.Queries.Podcasts.Categories do
  import Ecto.Query
  alias CastPub.Models.Podcast.Category
  alias CastPub.Repo

  def list(podcast_id) do
    query = from u in Category, 
            where: u.podcast_id == ^podcast_id, 
            select: u
    Repo.all(query)
  end

  def create(podcast_category) do
    CastPub.Queries.create(podcast_category)
  end

  def delete(id) do
    Repo.get(Category, id)
    |> Repo.delete
  end

  def delete_all(podcast_id) do
    list(podcast_id)
    |> Enum.each(fn(x) -> delete(x.id) end)
  end

  def create_podcast_categories(podcast_id, categories) do

    Repo.transaction(fn ->

      delete_all(podcast_id)

      saved_podcast_categories = Enum.map(categories, fn(x) -> 
        category = CastPub.Categories.get(x)
        podcast_category = %CastPub.Models.Podcast.Category{podcast_id: podcast_id, category: category}
        create(podcast_category)
      end)

    end)
  end
  
end