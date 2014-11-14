defmodule YappCast.UserController do
  use Phoenix.Controller

  plug :action

  def create(conn, _params) do
    render conn, "index"
  end

  def update(conn, _params) do
    render conn, "index"
  end

  def destroy(conn, _params) do
    send_response(conn, 404, "application/json","")
  end
  
end
