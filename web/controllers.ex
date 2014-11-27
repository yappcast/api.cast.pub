defmodule YappCast.Controllers do
  use Phoenix.Controller
  
  def send_json(conn, body, status \\ 200) do
    conn
    |> json(YappCast.Serialize.public(body))
    |> put_status(status)
  end

  def send_no_content(conn, status \\ 204) do
    conn
    |> put_status(status)
  end
end