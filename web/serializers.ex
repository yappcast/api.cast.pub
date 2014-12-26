defmodule CastPub.Serializers do

  defmodule User do
    def to_json(item) do
      Map.take(item, [:id, :email, :name])
    end
  end

  defmodule Category do
    def to_json(item) do
      IO.inspect(item)
      category = CastPub.Queries.Categories.get(item.category_id)
      IO.inspect(category)
      %{category_id: category.id, id: item.id, title: category.title}
    end
  end

  defmodule Podcast do
    def to_json(item) do
      new_podcast = Map.take(item, [
      :id, :title, :link, :copyright, :author, :block, :image_url, 
      :explicit, :complete, :new_feed_url, :owner, :owner_email, :subtitle, :summary])
      categories = Enum.map(item.categories.all, fn(x) -> Category.to_json(x) end)
      episodes = Enum.map(item.episodes.all, fn(x) -> CastPub.Serializers.Episode.to_json(x) end)
      Map.put(new_podcast, :categories, categories)
      |> Map.put(:episodes, episodes)
    end
  end

  defmodule Podcasts do
    def to_json(item) do
      %{ podcasts: Enum.map(item, fn(x) -> CastPub.Serializers.Podcast.to_json(x) end) }
    end
  end

  defmodule Episode do
    def to_json(item) do
      Map.take(item, [:id, :title, 
                  :author, :block, :image_url, :duration, 
                  :explicit, :is_closed_captioned, :order, 
                  :subtitle, :summary, :media_url])
    end
  end

  defmodule Episodes do
    def to_json(item) do
      %{ episodes: Enum.map(item, fn(x) -> CastPub.Serializers.Episode.to_json(x) end) }
    end
  end

end