defmodule YappCast.AuthController do
  use Phoenix.Controller

  plug :action

  def create(conn, _params) do
    render conn, "index"
  end
  
end
