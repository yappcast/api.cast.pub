defmodule YappCast.Queries.Podcasts do
  import Ecto.Query
  alias YappCast.Models.Podcast
  alias YappCast.Repo

  def get(id) do
    Repo.get(Podcast, id)
  end

  def get_by_slug(slug) do
    query = from u in Podcast,
          where: u.slug == ^slug,
         select: u

    Repo.one(query)
  end

  def list(company_id) do
    query = from u in Podcast,
          where: u.company_id == ^company_id,
         select: u

    Repo.all(query)
  end

  def create(podcast) do
    YappCast.Queries.create(podcast)
  end

  def update(id, data) do
    case get(id) do
      nil ->
        {:error, [{:error, :company, :company, "company not found"}]}
      updating_podcast ->
        
        updating_podcast
        |> YappCast.Queries.update_map_with_params(data, [
            :title, :link, :copyright, 
            :author, :block, :image_url, 
            :explicit, :complete, :new_feed_url, 
            :owner, :owner_email, :subtitle, :summary, 
            :slug
          ])
        |> YappCast.Queries.update
    end
  end

  def delete(id) do
    Repo.get(Podcast, id)
    |> Repo.delete
  end
end