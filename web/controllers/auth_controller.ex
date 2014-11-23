defmodule YappCast.AuthController do
  use Phoenix.Controller
  alias YappCast.Queries.Users
  plug :action

  def create(conn, params) do
    case generate_token(params["email"], params["password"]) do
      {:ok, jwt} ->
        json conn, 200, YappCast.Serialize.public(%{ token: jwt })
      {:error, _} ->
        json conn, 401, YappCast.Serialize.public(%{ status_code: 401, error: "Unable to authenticate", "description": "Invalid Username or Password" })
    end
  end

  defp generate_token(email, password) do
    case Users.credentials_ok?(email, password) do
      false ->
        {:error, "Invalid Username or Password"}
      true ->
        secret = Application.get_env(:yapp_cast, :key)
        user = Users.get_by_email(email)

        # Timex.Time.now(:secs) returns a float so we truncate it to an integer afterwards
        expires = Timex.Time.now(:secs) + Application.get_env(:yapp_cast, :token_expires) |> trunc
        Joken.encode(%{user_id: user.id, exp: expires}, secret, :HS256, %{})       
    end
  end
  
end
