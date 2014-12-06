defmodule PodcastControllerTest do
  use ExUnit.Case
  use ConnHelper
  alias CastPub.Repo

  setup context do
    Ecto.Migrator.run(Repo, "priv/repo/migrations", :up, [all: true])
    CastPub.Router.start

    on_exit fn ->
      CastPub.Router.stop
      Ecto.Migrator.run(Repo, "priv/repo/migrations", :down, [all: true])
    end

    conn = call(CastPub.Router, :post, "/api/users", [email: "three@four.com", password: "two", name: "three"])
    user = Poison.decode!(conn.resp_body, keys: :atoms!)

    conn = call(CastPub.Router, :post, "/api/auth", [email: "three@four.com", password: "two"])
    body = Poison.decode!(conn.resp_body, keys: :atoms!)


    context = Dict.put(context,:token, body.token) 
    |> Dict.put(:user_id, user.id) 
    |> Dict.put(:owner, "three") 
    |> Dict.put(:owner_email, "three@four.com")

    { :ok, context }
  end

  test "create a podcast", context do
    conn = call(CastPub.Router, :post, "/api/podcasts", 
      [
        title: "Podcast One", 
        user_id: context[:user_id], 
        owner: context[:owner],
        owner_email: context[:owner_email]
      ], headers: [{ "authorization", "Bearer #{context[:token]}" }])
    assert conn.status == 200
    body = Poison.decode!(conn.resp_body, keys: :atoms!)
    assert Map.has_key?(body, :id)
  end

  test "update a podcast", context do
    conn = call(CastPub.Router, :post, "/api/podcasts", 
      [
        title: "Podcast One", 
        user_id: context[:user_id], 
        owner: context[:owner],
        owner_email: context[:owner_email]
      ], headers: [{ "authorization", "Bearer #{context[:token]}" }])

    body = Poison.decode!(conn.resp_body, keys: :atoms!)
    conn = call(CastPub.Router, :patch, "/api/podcasts/#{body.id}", [title: "podcast1"], headers: [{ "authorization", "Bearer #{context[:token]}" }])
    assert conn.status == 204

    conn = call(CastPub.Router, :get, "/api/podcasts/#{body.id}", nil, headers: [{ "authorization", "Bearer #{context[:token]}" }])
    assert conn.status == 200
    body = Poison.decode!(conn.resp_body, keys: :atoms!)
    assert body.title == "podcast1"
  end

  test "delete a podcast", context do
    conn = call(CastPub.Router, :post, "/api/podcasts", 
      [
        title: "Podcast One", 
        user_id: context[:user_id], 
        owner: context[:owner],
        owner_email: context[:owner_email]
      ], headers: [{ "authorization", "Bearer #{context[:token]}" }])

    body = Poison.decode!(conn.resp_body, keys: :atoms!)
    conn = call(CastPub.Router, :delete, "/api/podcasts/#{body.id}", nil, headers: [{ "authorization", "Bearer #{context[:token]}" }])
    assert conn.status == 204
  end
end
