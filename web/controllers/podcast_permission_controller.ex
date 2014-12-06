defmodule CastPub.PodcastPermssionController do
  use Phoenix.Controller

  plug :action

  def index(conn, _params) do
    render conn, "index"
  end

  def show(conn, _params) do
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
