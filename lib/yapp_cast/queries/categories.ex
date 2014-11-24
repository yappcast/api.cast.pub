defmodule YappCast.Queries.Categories do
  import Ecto.Query
  alias YappCast.Models.Category
  alias YappCast.Repo

  def get(id) do
    Repo.get(Category, id)
  end

  def list() do
    query = from u in Category, select: u, preload: :sub_categories
    Repo.all(query)
  end

  def create(category) do
    YappCast.Queries.create(category)
  end

  def update(id, data) do
    case get(id) do
      nil ->
        {:error, [{:error, :category, :category, "category not found"}]}
      updating_category ->
        updating_category
        |> YappCast.Queries.update_map_with_params(data, [:title])
        |> YappCast.Queries.update
    end
  end

  def delete(id) do
    Repo.get(Category, id)
    |> Repo.delete
  end
end