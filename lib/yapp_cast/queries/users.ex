defmodule YappCast.Queries.Users do
  import Ecto.Query
  alias YappCast.Models.User
  alias YappCast.Repo

  def create(user) do
    Repo.insert(user)
  end

  def authenticate(username, password) do
    query = from u in User,
          where: u.username == ^username and u.password == ^password,
         select: u
    Repo.one(query)
  end
end