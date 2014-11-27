defprotocol YappCast.Serialize do
    @doc "For showing all data to owners and admins"
    @fallback_to_any true
    def private(resource)

    @doc "For public data"
    @fallback_to_any true
    def public(resource)
end

defimpl YappCast.Serialize, for: Any do
  def private(any), do: any
  def public(any), do: any
end

defimpl YappCast.Serialize, for: List do
  def private(list) do 
    serialize(list, &YappCast.Serialize.private/1)
  end

  def public(list) do 
    serialize(list, &YappCast.Serialize.public/1)
  end

  defp serialize(list, func) do
    Enum.map(list, fn(x) -> func.(x) end)
  end
end

defimpl YappCast.Serialize, for: YappCast.Models.User do
  def private(user), do: Map.take(user, [:id, :email, :name])
  def public(user), do: Map.take(user, [:id, :email, :name])
end

defimpl YappCast.Serialize, for: YappCast.Models.Company do
  def private(company), do: Map.take(company, [:id, :title, :slug])
  def public(company), do: Map.take(company, [:id, :title, :slug])
end

defimpl YappCast.Serialize, for: YappCast.Models.Podcast do
  def private(podcast), do: Map.take(podcast, [
    :id, :title, :link, :copyright, :author, :block, :image_url, 
    :explicit, :complete, :new_feed_url, :owner, :owner_email, :subtitle, :summary, :slug])
  
  def public(podcast), do: Map.take(podcast, [
    :id, :title, :link, :copyright, :author, :block, :image_url, 
    :explicit, :complete, :new_feed_url, :owner, :owner_email, :subtitle, :summary, :slug])
end