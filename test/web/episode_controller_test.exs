defmodule EpisodeControllerTest do
  use ExUnit.Case
  use RouterHelper
  alias CastPub.Repo

  setup context do
    Ecto.Migrator.run(Repo, "priv/repo/migrations", :up, [all: true])

    on_exit fn ->
      Ecto.Migrator.run(Repo, "priv/repo/migrations", :down, [all: true])
    end

    conn = call(CastPub.Router, :post, "/api/user", [email: "three@four.com", password: "two", name: "three"])
    user = Poison.decode!(conn.resp_body, keys: :atoms!)

    conn = call(CastPub.Router, :post, "/api/auth", [email: "three@four.com", password: "two"])
    body = Poison.decode!(conn.resp_body, keys: :atoms!)

    conn = call(CastPub.Router, :post, "/api/podcasts", 
      [
        title: "Podcast One", 
        user_id: user.id, 
        owner: "three",
        owner_email: "three@three.com"
      ], headers: [{ "authorization", "Bearer #{body.token}" }])
    podcast = Poison.decode!(conn.resp_body, keys: :atoms!)


    context = Dict.put(context,:token, body.token) 
    |> Dict.put(:podcast_id, podcast.id) 

    { :ok, context }
  end

  test "create an episode", context do
    conn = call(CastPub.Router, :post, "/api/episodes", 
      [
        title: "Episode One", 
        podcast_id: context[:podcast_id]
      ], headers: [{ "authorization", "Bearer #{context[:token]}" }])
    assert conn.status == 200
    body = Poison.decode!(conn.resp_body, keys: :atoms!)
    assert Map.has_key?(body, :id)
  end

  test "update an episode", context do
    conn = call(CastPub.Router, :post, "/api/episodes", 
      [
        title: "Episode One", 
        podcast_id: context[:podcast_id]
      ], headers: [{ "authorization", "Bearer #{context[:token]}" }])

    body = Poison.decode!(conn.resp_body, keys: :atoms!)
    conn = call(CastPub.Router, :patch, "/api/episodes/#{body.id}", [title: "episode1"], headers: [{ "authorization", "Bearer #{context[:token]}" }])
    assert conn.status == 204

    conn = call(CastPub.Router, :get, "/api/episodes/#{body.id}", nil, headers: [{ "authorization", "Bearer #{context[:token]}" }])
    assert conn.status == 200
    body = Poison.decode!(conn.resp_body, keys: :atoms!)
    assert body.title == "episode1"
  end

  test "delete an episode", context do
    conn = call(CastPub.Router, :post, "/api/episodes", 
      [
        title: "Episode One", 
        podcast_id: context[:podcast_id]
      ], headers: [{ "authorization", "Bearer #{context[:token]}" }])

    body = Poison.decode!(conn.resp_body, keys: :atoms!)
    conn = call(CastPub.Router, :delete, "/api/episodes/#{body.id}", nil, headers: [{ "authorization", "Bearer #{context[:token]}" }])
    assert conn.status == 204
  end
end
