defmodule YappCast.PodcastController do
  use Phoenix.Controller

  plug :action

  def index(conn, _params) do
    render conn, "index"
  end

  def show(conn, _params) do
    render conn, "index"
  end

  def new(conn, _params) do
    send_response(conn, 404, "application/json","")
  end

  def create(conn, _params) do
    render conn, "index"
  end

  def edit(conn, _params) do
    send_response(conn, 404, "application/json","")
  end

  def update(conn, _params) do
    render conn, "index"
  end

  def destroy(conn, _params) do
    send_response(conn, 404, "application/json","")
  end

  def not_found(conn, _params) do
    render conn, "not_found"
  end

  def error(conn, _params) do
    render conn, "error"
  end
end
