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

defimpl YappCast.Serialize, for: YappCast.Models.User do
  def private(user), do: Poison.encode!(%{id: user.id, email: user.email})
  def public(user), do: Poison.encode!(%{id: user.id, email: user.email})
end