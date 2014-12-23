defmodule CastPub.Queries.Podcasts do
  import Ecto.Query
  alias CastPub.Models.Podcast
  alias CastPub.Repo

  def get(id) do
    query = from u in Podcast,
          where: u.id == ^id,
          left_join: e in u.episodes,
          left_join: c in u.categories,
          select: assoc(u, [episodes: e, categories: c])

    Repo.one(query)
  end

  def list(user_id) do
    query = from u in Podcast,
          where: u.user_id == ^user_id,
          left_join: e in u.episodes,
          left_join: c in u.categories,
          select: assoc(u, [episodes: e, categories: c])

    Repo.all(query)
  end

  def build_podcast_from_params(params, user) do
    podcast = %Podcast{
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
      user_id: user.id
    }

    {podcast, Dict.get(params, "categories", [])}
  end

  def create(podcast, categories) do
    case Vex.errors(podcast) do
      [] ->
        Repo.transaction(fn ->
          saved_podcast = Repo.insert(podcast)
          CastPub.Queries.Podcasts.Categories.create_podcast_categories(saved_podcast.id, categories)
          get(saved_podcast.id)
        end)
      errors ->
        {:error, errors}       
    end
  end

  def update(id, data) do
    case get(id) do
      nil ->
        {:error, [{:error, :podcast, :podcast, "podcast not found"}]}
      updating_podcast ->

        case Vex.errors(updating_podcast) do
          [] ->
            Repo.transaction(fn ->
              updating_podcast
              |> CastPub.Queries.update_map_with_params(data, [
                  :title, :link, :copyright, 
                  :author, :block, :image_url, 
                  :explicit, :complete, :new_feed_url, 
                  :owner, :owner_email, :subtitle, :summary
                ])
              |> Repo.update

              if Dict.get(data, "categories", nil) != nil do
                CastPub.Queries.Podcasts.Categories.create_podcast_categories(updating_podcast.id, Dict.get(data, "categories"))          
              end
            end)

          errors ->
            {:error, errors}       
        end
    end
  end

  def delete(id) do
    Repo.get(Podcast, id)
    |> Repo.delete
  end
end