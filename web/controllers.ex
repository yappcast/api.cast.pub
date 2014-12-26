defmodule CastPub.Controllers do
  use Phoenix.Controller
  
  def send_json(conn, body, status \\ 200) do
    conn
    |> put_status(status)
    |> json(body)
    |> halt
  end

  def send_model(conn, body, serializer, status \\ 200) do
    conn
    |> put_status(status)
    |> put_resp_content_type("application/json")
    |> json(serializer.to_json(body))
    |> halt
  end

  def send_no_content(conn, status \\ 204) do
    conn
    |> put_status(status)
    |> halt
  end
end