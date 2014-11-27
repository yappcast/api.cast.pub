defmodule YappCast.CompanyController do
  use Phoenix.Controller
  alias YappCast.Queries.Companies
  alias YappCast.Models.Company

  plug :action

  def index(conn, _params) do
    companies = Companies.list(conn.assigns.claims.user_id)
    YappCast.Controllers.send_json(conn, companies)  
  end

  def show(conn, params) do
    case Companies.get_by_slug(params["slug"]) do
      nil ->
        YappCast.Controllers.send_no_content(conn, 404) 
      company ->
        case Canada.Can.can?(conn.assigns.user, :read, company) do
          true ->
            YappCast.Controllers.send_json(conn, company) 
          false ->
            YappCast.Controllers.send_no_content(conn, 401)   
        end                
    end
  end

  def create(conn, params) do
    company = %Company{title: Dict.get(params, "title"), slug: Dict.get(params, "slug"), user_id: conn.assigns.claims.user_id}
    case Companies.create(company) do
      {:error, errors} ->
        YappCast.Controllers.send_json(conn, errors, 400) 
      {:ok, company} ->
        YappCast.Controllers.send_json(conn, company)     
    end
  end

  def update(conn, params) do
    case Companies.get_by_slug(params["slug"]) do
      nil ->
        YappCast.Controllers.send_json(conn, "", 404)
      company ->
        case Canada.Can.can?(conn.assigns.user, :update, company) do
          true ->
            case Companies.update(company.id, params) do
              {:error, errors} ->
                YappCast.Controllers.send_json(conn, errors, 400) 
              {:ok, _} ->
                YappCast.Controllers.send_no_content(conn)  
            end
          false ->
            YappCast.Controllers.send_no_content(conn, 401)             
        end
    end
  end

  def destroy(conn, params) do
    company = Companies.get_by_slug(params["slug"])

    case Canada.Can.can?(conn.assigns.user, :delete, company) do
      true ->
        Companies.delete(company.id)
        YappCast.Controllers.send_no_content(conn)  
      false ->
        YappCast.Controllers.send_no_content(conn, 401)           
    end
  end
end
