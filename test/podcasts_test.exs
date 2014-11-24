defmodule PodcastsTest do
  use ShouldI
  alias YappCast.Repo
  alias YappCast.Models.User
  alias YappCast.Models.Company
  alias YappCast.Models.Podcast
  alias YappCast.Queries.Users
  alias YappCast.Queries.Companies
  alias YappCast.Queries.Podcasts

  with "creating a podcast" do
    setup_all context do
      Ecto.Migrator.run(Repo, "priv/repo/migrations", :up, [all: true])

      on_exit fn ->
        Ecto.Migrator.run(Repo, "priv/repo/migrations", :down, [all: true])
      end

      user = %User{ email: "three@four.com", password: "two", name: "name" }
      {:ok, saved_user } = Users.create(user)

      company = %Company{ title: "two", slug: "two", user_id: saved_user.id }
      {:ok, saved_company } = Companies.create(company)

      { :ok, Dict.put(context, :company, company) |> Dict.put(:user, user) }
    end

    should "create podcast when all required fields are present", context do
      podcast = %Podcast{ title: "two", slug: "two", 
      company_id: context[:company].id, 
      owner: context[:user].name, 
      owner_email: context[:user].email }

      {:ok, saved_podcast } = Podcasts.create(podcast)
      assert podcast.title == saved_podcast.title
      assert podcast.slug == saved_podcast.slug
    end

  end

  with "updating podcast" do
    setup_all context do
      Ecto.Migrator.run(Repo, "priv/repo/migrations", :up, [all: true])

      on_exit fn ->
        Ecto.Migrator.run(Repo, "priv/repo/migrations", :down, [all: true])
      end

      user = %User{ email: "three@four.com", password: "two", name: "name" }
      {:ok, saved_user } = Users.create(user)

      company = %Company{ title: "two", slug: "two", user_id: saved_user.id }
      {:ok, saved_company } = Companies.create(company)

      podcast = %Podcast{ title: "two", slug: "two", 
      company_id: saved_company.id, 
      owner: user.name, 
      owner_email: user.email }
      {:ok, saved_podcast } = Podcasts.create(podcast)

      { :ok, Dict.put(context, :podcast, saved_podcast) }
    end

    should "update company when update fields are valid", context  do
      {status, _} = Podcasts.update(context[:podcast].id, [title: "newTitle"])
      assert status == :ok

      updated = Podcasts.get(context[:podcast].id)
      assert updated.title == "newTitle"
    end

  end

  with "permissions" do
    setup_all context do
      Ecto.Migrator.run(Repo, "priv/repo/migrations", :up, [all: true])

      on_exit fn ->
        Ecto.Migrator.run(Repo, "priv/repo/migrations", :down, [all: true])
      end

      {:ok, context }
    end

    should "not allow access to another user's podcast" do
      user_one = %User{ password: "one", email: "three@four.com", name: "name" }
      {:ok, saved_user_one } = Users.create(user_one)

      user_two = %User{ password: "two", email: "four@four.com", name: "name2" }
      {:ok, saved_user_two } = Users.create(user_two)

      company = %Company{ title: "two", slug: "two", user_id: saved_user_one.id }
      {:ok, saved_company } = Companies.create(company)

      podcast = %Podcast{ title: "two", slug: "two", 
      company_id: saved_company.id, 
      owner: user_one.name, 
      owner_email: user_one.email }
      {:ok, saved_podcast } = Podcasts.create(podcast)

      assert Canada.Can.can?(saved_user_one, :read, podcast) == true
      assert Canada.Can.can?(saved_user_two, :read, podcast) == false
    end

  end
end
