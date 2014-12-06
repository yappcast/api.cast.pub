defmodule CastPub.AuthController do
  use Phoenix.Controller
  alias CastPub.Queries.Users
  plug :action

  def create(conn, params) do
    case generate_token(params["email"], params["password"]) do
      {:ok, jwt} ->
        CastPub.Controllers.send_json(conn, %{ token: jwt })
      {:error, _} ->
        error = %{ status_code: 401, error: "Unable to authenticate", "description": "Invalid Username or Password" }
        CastPub.Controllers.send_json(conn, error, 401)
    end
  end

  defp generate_token(email, password) do
    case Users.credentials_ok?(email, password) do
      false ->
        {:error, "Invalid Username or Password"}
      true ->
        secret = Application.get_env(:cast_pub, :key)
        user = Users.get_by_email(email)

        # Timex.Time.now(:secs) returns a float so we truncate it to an integer afterwards
        expires = Timex.Time.now(:secs) + Application.get_env(:cast_pub, :token_expires) |> trunc
        Joken.encode(%{user_id: user.id, exp: expires}, secret, :HS256, %{})       
    end
  end
  
end
