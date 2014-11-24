defmodule YappCast.Queries.Companies do
  import Ecto.Query
  alias YappCast.Models.Company
  alias YappCast.Repo

  def get(id) do
    Repo.get(Company, id)
  end

  def get_by_slug(slug) do
    query = from u in Company,
          where: u.slug == ^slug,
         select: u

    Repo.one(query)
  end

  def list(user_id) do
    query = from u in Company,
          where: u.user_id == ^user_id,
         select: u

    Repo.all(query)
  end

  def create(company) do
    YappCast.Queries.create(company)
  end

  def update(id, data) do
    case get(id) do
      nil ->
        {:error, [{:error, :company, :company, "company not found"}]}
      updating_company ->
        updating_company
        |> YappCast.Queries.update_map_with_params(data, [:title, :slug])
        |> YappCast.Queries.update
    end
  end

  def delete(id) do
    Repo.get(Company, id)
    |> Repo.delete
  end
end