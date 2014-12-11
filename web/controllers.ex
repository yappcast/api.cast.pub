defmodule CastPub.Controllers do
  use Phoenix.Controller
  
  def send_json(conn, body, status \\ 200) do
    conn
    |> put_status(status)
    |> json(CastPub.Serialize.public(body))
    |> halt
  end

  def send_no_content(conn, status \\ 204) do
    conn
    |> put_status(status)
    |> halt
  end
end