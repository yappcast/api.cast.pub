defmodule PodcastsTest do
  use ExUnit.Case
  alias YappCast.Repo
  alias YappCast.Models.User
  alias YappCast.Models.Company
  alias YappCast.Models.Podcast
  alias YappCast.Queries.Users
  alias YappCast.Queries.Companies
  alias YappCast.Queries.Podcasts

  setup context do
    Ecto.Migrator.run(Repo, "priv/repo/migrations", :up, [all: true])

    on_exit fn ->
      Ecto.Migrator.run(Repo, "priv/repo/migrations", :down, [all: true])
    end

    user = %User{ email: "three@four.com", password: "two", name: "name" }
    {:ok, saved_user } = Users.create(user)

    company = %Company{ title: "two", slug: "two", user_id: saved_user.id }
    {:ok, saved_company } = Companies.create(company)

    { :ok, Dict.put(context, :company, saved_company) |> Dict.put(:user, saved_user) }
  end

  test "create podcast when all required fields are present", context do
    podcast = %Podcast{ title: "two", slug: "two", 
    company_id: context[:company].id, 
    owner: context[:user].name, 
    owner_email: context[:user].email }

    {:ok, saved_podcast } = Podcasts.create(podcast)
    assert podcast.title == saved_podcast.title
    assert podcast.slug == saved_podcast.slug
  end

  test "update company when update fields are valid", context  do
    podcast = %Podcast{ title: "two", slug: "two", 
    company_id: context[:company].id, 
    owner: context[:user].name, 
    owner_email: context[:user].email }
    {:ok, saved_podcast } = Podcasts.create(podcast)
    
    {status, _} = Podcasts.update(saved_podcast.id, %{"title" => "newTitle"})
    assert status == :ok

    updated = Podcasts.get(saved_podcast.id)
    assert updated.title == "newTitle"
  end

  test "not allow access to another user's podcast", context do
    user_two = %User{ password: "two", email: "four@four.com", name: "name2" }
    {:ok, user_two } = Users.create(user_two)

    podcast = %Podcast{ title: "two", slug: "two", 
    company_id: context[:company].id, 
    owner: context[:user].name, 
    owner_email: context[:user].email }
    {:ok, saved_podcast } = Podcasts.create(podcast)

    assert Canada.Can.can?(context[:user], :read, saved_podcast) == true
    assert Canada.Can.can?(user_two, :read, saved_podcast) == false
  end
end
