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

  def build_podcast_from_params(params, user) do
    %Podcast{
      title: Dict.get(params, "title"),
      link: Dict.get(params, "link"),
      copyright: Dict.get(params, "copyright"),
      author: Dict.get(params, "author"),
      block: Dict.get(params, "block", false),
      image_url: Dict.get(params, "image_url"),
      explicit: Dict.get(params, "explicit", false),
      complete: Dict.get(params, "complete", false),
      new_feed_url: Dict.get(params, "new_feed_url"),
      owner: Dict.get(params, "owner", user.name),
      owner_email: Dict.get(params, "owner_email", user.email),
      subtitle: Dict.get(params, "subtitle"),
      summary: Dict.get(params, "summary"),
      slug: Dict.get(params, "slug"),
      company_id: Dict.get(params, "company_id")
    }
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