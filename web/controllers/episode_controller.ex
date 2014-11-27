defmodule YappCast.EpisodeController do
  use Phoenix.Controller

  plug :action

  def show(conn, _params) do
    render conn, "index"
  end

  def download(conn, _params) do
    render conn, "index"
  end

  def create(conn, _params) do
    render conn, "index"
  end

  def update(conn, _params) do
    render conn, "index"
  end

  def destroy(conn, _params) do
    render conn, "index"
  end
end
