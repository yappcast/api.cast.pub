defmodule UserControllerTest do
  use ExUnit.Case
  use RouterHelper
  alias CastPub.Repo

  setup _context do
    Ecto.Migrator.run(Repo, "priv/repo/migrations", :up, [all: true])

    on_exit fn ->
      Ecto.Migrator.run(Repo, "priv/repo/migrations", :down, [all: true])
    end

    :ok
  end

  test "create a user" do
    conn = call(CastPub.Router, :post, "/api/user", [email: "three@four.com", password: "two", name: "three"])
    assert conn.status == 200
    body = Poison.decode!(conn.resp_body, keys: :atoms!)
    assert Map.has_key?(body, :id)
  end

  test "update a user" do
    conn = call(CastPub.Router, :post, "/api/user", [email: "three@four.com", password: "two", name: "three"])
    assert conn.status == 200

    conn = call(CastPub.Router, :post, "/api/auth", [email: "three@four.com", password: "two"])
    assert conn.status == 200
    body = Poison.decode!(conn.resp_body, keys: :atoms!)

    conn = call(CastPub.Router, :patch, "/api/user", [emaill: "pizza@hut.com"], headers: [{ "authorization", "Bearer #{body.token}" }])
    assert conn.status == 204
  end

  test "delete a user" do
    conn = call(CastPub.Router, :post, "/api/user", [email: "three@four.com", password: "two", name: "three"])
    assert conn.status == 200

    conn = call(CastPub.Router, :post, "/api/auth", [email: "three@four.com", password: "two"])
    assert conn.status == 200
    body = Poison.decode!(conn.resp_body, keys: :atoms!)

    conn = call(CastPub.Router, :delete, "/api/user", nil, headers: [{ "authorization", "Bearer #{body.token}" }])
    assert conn.status == 204
  end
end
