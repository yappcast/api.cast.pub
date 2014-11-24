defmodule YappCast.UserController do
  use Phoenix.Controller
  alias YappCast.Queries.Users
  alias YappCast.Models.User

  plug :action

  def show(conn, _params) do
    user = Users.get(conn.assigns.claims.user_id)
    json conn, 200, YappCast.Serialize.public(user)      
  end

  def create(conn, params) do

    case Users.create(%User{email: Dict.get(params, "email"), password: Dict.get(params, "password"), name: Dict.get(params, "name")}) do
      {:error, errors} ->
        json conn, 400, YappCast.Serialize.public(errors)
      {:ok, user} ->
        json conn, 200, YappCast.Serialize.public(user)      
    end

  end

  def update(conn, params) do

    case Users.update(conn.assigns.claims.user_id, Dict.get(params, "email"), Dict.get(params, "password"), Dict.get(params, "name")) do
      {:error, errors} ->
        json conn, 400, YappCast.Serialize.public(errors)
      {:ok, _} ->
        json conn, 204, ""     
    end

  end

  def destroy(conn, _params) do

    case Users.delete(conn.assigns.claims.user_id) do
      :ok ->
        json conn, 204, "" 
      {:ok, _} ->
        json conn, 400, "" 
    end

  end
  
end
