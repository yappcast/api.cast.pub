defmodule PodcastsTest do
  use ExUnit.Case
  alias CastPub.Repo
  alias CastPub.Models.User
  alias CastPub.Models.Podcast
  alias CastPub.Queries.Users
  alias CastPub.Queries.Podcasts

  setup context do
    Ecto.Migrator.run(Repo, "priv/repo/migrations", :up, [all: true])

    on_exit fn ->
      Ecto.Migrator.run(Repo, "priv/repo/migrations", :down, [all: true])
    end

    user = %User{ email: "three@four.com", password: "two", name: "name" }
    {:ok, saved_user } = Users.create(user)

    { :ok, Dict.put(context, :user, saved_user) }
  end

  test "create podcast when all required fields are present", context do
    podcast = %Podcast{ title: "two", 
    user_id: context[:user].id, 
    owner: context[:user].name, 
    owner_email: context[:user].email }

    {:ok, saved_podcast } = Podcasts.create(podcast, [])
    assert podcast.title == saved_podcast.title
  end

  test "update podcast when update fields are valid", context  do
    podcast = %Podcast{ title: "two",
    user_id: context[:user].id, 
    owner: context[:user].name, 
    owner_email: context[:user].email }
    {:ok, saved_podcast } = Podcasts.create(podcast, [])
    
    {status, _} = Podcasts.update(saved_podcast.id, %{"title" => "newTitle"})
    assert status == :ok

    updated = Podcasts.get(saved_podcast.id)
    assert updated.title == "newTitle"
  end

  test "not allow access to another user's podcast", context do
    user_two = %User{ password: "two", email: "four@four.com", name: "name2" }
    {:ok, user_two } = Users.create(user_two)

    podcast = %Podcast{ title: "two", 
    user_id: context[:user].id, 
    owner: context[:user].name, 
    owner_email: context[:user].email }
    {:ok, saved_podcast } = Podcasts.create(podcast, [])

    assert Canada.Can.can?(context[:user], :read, saved_podcast) == true
    assert Canada.Can.can?(user_two, :read, saved_podcast) == false
  end
end
