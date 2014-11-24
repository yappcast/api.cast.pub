defprotocol YappCast.Serialize do
    @doc "For showing all data to owners and admins"
    @fallback_to_any true
    def private(resource)

    @doc "For public data"
    @fallback_to_any true
    def public(resource)
end

defimpl YappCast.Serialize, for: Any do
  def private(any), do: Poison.encode!(any)
  def public(any), do: Poison.encode!(any)
end

defimpl YappCast.Serialize, for: List do
  def private(list) do 
    serialize(list, &YappCast.Serialize.private/1)
  end

  def public(list) do 
    serialize(list, &YappCast.Serialize.public/1)
  end

  defp serialize(list, func) do
    list_str = Enum.map(list, fn(x) -> func.(x) end) 
    |> Enum.join(",")

    "[#{list_str}]"
  end
end

defimpl YappCast.Serialize, for: YappCast.Models.User do
  def private(user), do: Poison.encode!(%{id: user.id, email: user.email, name: user.name})
  def public(user), do: Poison.encode!(%{id: user.id, email: user.email, name: user.name})
end

defimpl YappCast.Serialize, for: YappCast.Models.Company do
  def private(company), do: Poison.encode!(%{id: company.id, title: company.title, slug: company.slug})
  def public(company), do: Poison.encode!(%{id: company.id, title: company.title, slug: company.slug})
end