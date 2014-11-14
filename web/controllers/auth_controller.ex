defmodule YappCast.AuthController do
  use Phoenix.Controller

  plug :action

  def create(conn, _params) do
    json conn, Poison.encode!(%{})
  end
  
end
