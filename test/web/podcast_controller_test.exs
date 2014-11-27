defmodule PodcastControllerTest do
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

    conn = call(YappCast.Router, :post, "/api/companies", [title: "Company One", slug: "company1"], headers: [{ "authorization", "Bearer #{body.token}" }])
    company = Poison.decode!(conn.resp_body, keys: :atoms!)

    context = Dict.put(context,:token, body.token) 
    |> Dict.put(:company_id, company.id) 
    |> Dict.put(:owner, "three") 
    |> Dict.put(:owner_email, "three@four.com")

    { :ok, context }
  end

  test "create a podcast", context do
    conn = call(YappCast.Router, :post, "/api/podcasts", 
      [
        title: "Podcast One", 
        slug: "podcast1", 
        company_id: context[:company_id], 
        owner: context[:owner],
        owner_email: context[:owner_email]
      ], headers: [{ "authorization", "Bearer #{context[:token]}" }])
    assert conn.status == 200
    body = Poison.decode!(conn.resp_body, keys: :atoms!)
    assert Map.has_key?(body, :id)
  end

  test "update a podcast", context do
    call(YappCast.Router, :post, "/api/podcasts", 
      [
        title: "Podcast One", 
        slug: "podcast1", 
        company_id: context[:company_id], 
        owner: context[:owner],
        owner_email: context[:owner_email]
      ], headers: [{ "authorization", "Bearer #{context[:token]}" }])

    conn = call(YappCast.Router, :patch, "/api/podcasts/podcast1", [title: "podcast1"], headers: [{ "authorization", "Bearer #{context[:token]}" }])
    assert conn.status == 204

    conn = call(YappCast.Router, :get, "/api/podcasts/podcast1", nil, headers: [{ "authorization", "Bearer #{context[:token]}" }])
    assert conn.status == 200
    body = Poison.decode!(conn.resp_body, keys: :atoms!)
    assert body.title == "podcast1"
  end

  test "delete a podcast", context do
    call(YappCast.Router, :post, "/api/podcasts", 
      [
        title: "Podcast One", 
        slug: "podcast1", 
        company_id: context[:company_id], 
        owner: context[:owner],
        owner_email: context[:owner_email]
      ], headers: [{ "authorization", "Bearer #{context[:token]}" }])

    conn = call(YappCast.Router, :delete, "/api/podcasts/podcast1", nil, headers: [{ "authorization", "Bearer #{context[:token]}" }])
    assert conn.status == 204
  end
end
