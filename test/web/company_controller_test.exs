defmodule CompanyControllerTest do
  use ExUnit.Case
  use ConnHelper
  alias YappCast.Repo

  setup context do
    Ecto.Migrator.run(Repo, "priv/repo/migrations", :up, [all: true])
    YappCast.Router.start

    on_exit fn ->
      YappCast.Router.stop
      Ecto.Migrator.run(Repo, "priv/repo/migrations", :down, [all: true])
    end

    call(YappCast.Router, :post, "/api/users", [email: "three@four.com", password: "two", name: "three"])
    conn = call(YappCast.Router, :post, "/api/auth", [email: "three@four.com", password: "two"])
    body = Poison.decode!(conn.resp_body, keys: :atoms!)

    { :ok, Dict.put(context,:token, body.token) }
  end

  test "create a company", context do
    conn = call(YappCast.Router, :post, "/api/companies", [title: "Company One", slug: "company1"], headers: [{ "authorization", "Bearer #{context[:token]}" }])
    assert conn.status == 200
    body = Poison.decode!(conn.resp_body, keys: :atoms!)
    assert Map.has_key?(body, :id)
  end

  test "update a company", context do
    call(YappCast.Router, :post, "/api/companies", [title: "Company One", slug: "company1"], headers: [{ "authorization", "Bearer #{context[:token]}" }])
    conn = call(YappCast.Router, :patch, "/api/companies/company1", [title: "Company1"], headers: [{ "authorization", "Bearer #{context[:token]}" }])
    assert conn.status == 204
  end

  test "delete a company", context do
    call(YappCast.Router, :post, "/api/companies", [title: "Company One", slug: "company1"], headers: [{ "authorization", "Bearer #{context[:token]}" }])
    conn = call(YappCast.Router, :delete, "/api/companies/company1", nil, headers: [{ "authorization", "Bearer #{context[:token]}" }])
    assert conn.status == 204
  end
end
