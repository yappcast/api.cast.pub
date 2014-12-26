defmodule CastPub.UserController do
  use Phoenix.Controller
  alias CastPub.Queries.Users
  alias CastPub.Models.User

  plug :action

  def show(conn, _params) do
    CastPub.Controllers.send_model(conn, conn.assigns.user, CastPub.Serializers.User)    
  end

  def create(conn, params) do

    case Users.create(%User{email: Dict.get(params, "email"), password: Dict.get(params, "password"), name: Dict.get(params, "name")}) do
      {:error, errors} ->
        CastPub.Controllers.send_json(conn, errors, 400)
      {:ok, user} ->
        CastPub.Controllers.send_model(conn, user, CastPub.Serializers.User)     
    end

  end

  def update(conn, params) do

    case Users.update(conn.assigns.claims.user_id, Dict.get(params, "email"), Dict.get(params, "password"), Dict.get(params, "name")) do
      {:error, errors} ->
        CastPub.Controllers.send_json(conn, errors, 400)
      {:ok, _} ->
        CastPub.Controllers.send_no_content(conn)     
    end

  end

  def destroy(conn, _params) do
    Users.delete(conn.assigns.claims.user_id)
    CastPub.Controllers.send_no_content(conn)  
  end
  
end
