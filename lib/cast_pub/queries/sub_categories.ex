defmodule CastPub.Queries.SubCategories do
  import Ecto.Query
  alias CastPub.Models.SubCategory
  alias CastPub.Repo

  def get(id) do
    Repo.get(SubCategory, id)
  end

  def list(category_id) do
    query = from u in Category, 
            where: u.category_id == ^category_id,
            select: u, 
            preload: :category

    Repo.all(query)
  end

  def create(sub_category) do
    CastPub.Queries.create(sub_category)
  end

  def update(id, data) do
    case get(id) do
      nil ->
        {:error, [{:error, :sub_category, :sub_category, "subcategory not found"}]}
      updating_sub_category ->
        updating_sub_category
        |> CastPub.Queries.update_map_with_params(data, [:title])
        |> CastPub.Queries.update
    end
  end

  def delete(id) do
    Repo.get(SubCategory, id)
    |> Repo.delete
  end
end