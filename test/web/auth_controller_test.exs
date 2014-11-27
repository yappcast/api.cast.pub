  defmodule AuthControllerTest do
  use ExUnit.Case
  use ConnHelper
  alias YappCast.Repo
  alias YappCast.Models.User
  alias YappCast.Queries.Users

  setup_all context do
    Ecto.Migrator.run(Repo, "priv/repo/migrations", :up, [all: true])
    YappCast.Router.start

    on_exit fn ->
      YappCast.Router.stop
      Ecto.Migrator.run(Repo, "priv/repo/migrations", :down, [all: true])
    end

    user = %User{ email: "three@four.com", password: "two", name: "name" }
    {:ok, _saved_user } = Users.create(user)

    { :ok, context }
  end

  test "not let anyone in with bad credentials", _context do
    conn = call(YappCast.Router, :post, "/api/auth", [email: "blah", password: "blah"])
    assert conn.status == 401
  end

  test "let in valid user", _context do
    conn = call(YappCast.Router, :post, "/api/auth", [email: "three@four.com", password: "two"])
    assert conn.status == 200
    body = Poison.decode!(conn.resp_body)
    assert Map.has_key?(body, "token")
  end
end
