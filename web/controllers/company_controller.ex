defmodule YappCast.CompanyController do
  use Phoenix.Controller
  alias YappCast.Queries.Companies
  alias YappCast.Models.Company
  alias YappCast.Queries.Users

  plug :action

  def index(conn, _params) do
    companies = Companies.list(conn.claims.user_id)
    json conn, 200, YappCast.Serialize.public(companies)   
  end

  def show(conn, params) do
    user = Users.get(conn.claims.user_id)
    company = Companies.get_by_slug(params["slug"])

    case Canada.Can.can?(user, :read, company) do
      true ->
        json conn, 200, YappCast.Serialize.public(company)
      false ->
        json conn, 401, ""             
    end
  end

  def create(conn, params) do
    case Companies.create(%Company{title: Dict.get(params, "title"), slug: Dict.get(params, "slug")}) do
      {:error, errors} ->
        json conn, 400, YappCast.Serialize.public(errors)
      {:ok, company} ->
        json conn, 200, YappCast.Serialize.public(company)      
    end
  end

  def update(conn, params) do
    user = Users.get(conn.claims.user_id)
    company = Companies.get_by_slug(params["slug"])

    case Canada.Can.can?(user, :update, company) do
      true ->
        case Companies.update(company.id, params) do
          {:error, errors} ->
            json conn, 400, YappCast.Serialize.public(errors)
          {:ok, _} ->
            json conn, 204, ""     
        end
      false ->
        json conn, 401, ""             
    end
  end

  def destroy(conn, params) do
    user = Users.get(conn.claims.user_id)
    company = Companies.get_by_slug(params["slug"])

    case Canada.Can.can?(user, :delete, company) do
      true ->
        Companies.delete(company.id)
      false ->
        json conn, 401, ""             
    end
  end
end
