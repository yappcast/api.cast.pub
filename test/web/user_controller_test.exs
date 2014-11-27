defmodule UserControllerTest do
  use ExUnit.Case
  use ConnHelper
  alias YappCast.Repo

  setup _context do
    Ecto.Migrator.run(Repo, "priv/repo/migrations", :up, [all: true])
    YappCast.Router.start

    on_exit fn ->
      YappCast.Router.stop
      Ecto.Migrator.run(Repo, "priv/repo/migrations", :down, [all: true])
    end

    :ok
  end

  test "create a user" do
    conn = call(YappCast.Router, :post, "/api/users", [email: "three@four.com", password: "two", name: "three"])
    assert conn.status == 200
    body = Poison.decode!(conn.resp_body, keys: :atoms!)
    assert Map.has_key?(body, :id)
  end

  test "update a user" do
    conn = call(YappCast.Router, :post, "/api/users", [email: "three@four.com", password: "two", name: "three"])
    assert conn.status == 200

    conn = call(YappCast.Router, :post, "/api/auth", [email: "three@four.com", password: "two"])
    assert conn.status == 200
    body = Poison.decode!(conn.resp_body, keys: :atoms!)

    conn = call(YappCast.Router, :patch, "/api/users/current", [emaill: "pizza@hut.com"], headers: [{ "authorization", "Bearer #{body.token}" }])
    assert conn.status == 204
  end

  test "delete a user" do
    conn = call(YappCast.Router, :post, "/api/users", [email: "three@four.com", password: "two", name: "three"])
    assert conn.status == 200

    conn = call(YappCast.Router, :post, "/api/auth", [email: "three@four.com", password: "two"])
    assert conn.status == 200
    body = Poison.decode!(conn.resp_body, keys: :atoms!)

    conn = call(YappCast.Router, :delete, "/api/users/current", nil, headers: [{ "authorization", "Bearer #{body.token}" }])
    assert conn.status == 204
  end
end
