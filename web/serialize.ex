defprotocol CastPub.Serialize do
    @doc "For showing all data to owners and admins"
    @fallback_to_any true
    def private(resource)

    @doc "For public data"
    @fallback_to_any true
    def public(resource)
end

defimpl CastPub.Serialize, for: Any do
  def private(any), do: any
  def public(any), do: any
end

defimpl CastPub.Serialize, for: List do
  def private(list) do 
    serialize(list, &CastPub.Serialize.private/1)
  end

  def public(list) do 
    serialize(list, &CastPub.Serialize.public/1)
  end

  defp serialize(list, func) do
    Enum.map(list, fn(x) -> func.(x) end)
  end
end

defimpl CastPub.Serialize, for: CastPub.Models.User do
  def private(user), do: Map.take(user, [:id, :email, :name])
  def public(user), do: Map.take(user, [:id, :email, :name])
end

defimpl CastPub.Serialize, for: CastPub.Models.Podcast.Category do
  def private(podcast_category) do
    category = podcast_category.category.get
    %{category: category, id: podcast_category.id}
  end
  def public(podcast_category) do
    category = podcast_category.category.get
    %{category: category, id: podcast_category.id}
  end
end

defimpl CastPub.Serialize, for: CastPub.Models.Podcast do
  def private(podcast) do
    new_podcast = Map.take(podcast, [
    :id, :title, :link, :copyright, :author, :block, :image_url, 
    :explicit, :complete, :new_feed_url, :owner, :owner_email, :subtitle, :summary])
    categories = Enum.map(podcast.categories.all, fn(x) -> CastPub.Serialize.public(x) end)
    episodes = Enum.map(podcast.categories.all, fn(x) -> CastPub.Serialize.public(x) end)
    Map.put(new_podcast, :categories, categories)
    |> Map.put(:episodes, episodes)
  end
  
  def public(podcast) do
    new_podcast = Map.take(podcast, [
    :id, :title, :link, :copyright, :author, :block, :image_url, 
    :explicit, :complete, :new_feed_url, :owner, :owner_email, :subtitle, :summary])
    categories = Enum.map(podcast.categories.all, fn(x) -> CastPub.Serialize.public(x) end)
    episodes = Enum.map(podcast.categories.all, fn(x) -> CastPub.Serialize.public(x) end)
    Map.put(new_podcast, :categories, categories)
    |> Map.put(:episodes, episodes)
  end
end

defimpl CastPub.Serialize, for: CastPub.Models.Episode do
  def private(episode), do: Map.take(episode, [:id, :title, :publish_date, 
            :author, :block, :image_url, :duration, 
            :explicit, :is_closed_captioned, :order, 
            :subtitle, :summary, :media_url])
  
  def public(episode), do: Map.take(episode, [:id, :title, :publish_date, 
            :author, :block, :image_url, :duration, 
            :explicit, :is_closed_captioned, :order, 
            :subtitle, :summary, :media_url])
end