defmodule CompaniesTest do
  use ShouldI
  alias YappCast.Repo
  alias YappCast.Models.User
  alias YappCast.Models.Company
  alias YappCast.Queries.Users
  alias YappCast.Queries.Companies

  with "creating a company" do
    setup_all context do
      Ecto.Migrator.run(Repo, "priv/repo/migrations", :up, [all: true])

      on_exit fn ->
        Ecto.Migrator.run(Repo, "priv/repo/migrations", :down, [all: true])
      end

      user = %User{ email: "three@four.com", password: "two", name: "name" }
      {:ok, saved_user } = Users.create(user)

      { :ok, Dict.put(context, :user, saved_user) }
    end

    should "not create company when title missing", context do
      company = %Company{ slug: "two", user_id: context[:user].id }
      {status, _ } = Companies.create(company)
      assert status == :error
    end

    should "not create company when slug missing", context do
      company = %Company{ title: "two", user_id: context[:user].id }
      {status, _ } = Companies.create(company)
      assert status == :error
    end

    should "create company when all required fields are present", context do
      company = %Company{ title: "two", slug: "two", user_id: context[:user].id }
      {:ok, saved_company } = Companies.create(company)
      assert company.title == saved_company.title
      assert company.slug == saved_company.slug
    end

  end

  with "updating company" do
    setup_all context do
      Ecto.Migrator.run(Repo, "priv/repo/migrations", :up, [all: true])

      on_exit fn ->
        Ecto.Migrator.run(Repo, "priv/repo/migrations", :down, [all: true])
      end

      user = %User{ email: "three@four.com", password: "two", name: "name" }
      {:ok, saved_user } = Users.create(user)

      company = %Company{ title: "two", slug: "two", user_id: saved_user.id }
      {:ok, saved_company } = Companies.create(company)

      { :ok, Dict.put(context, :company, saved_company) }
    end

    should "not update company when title is invalid", context do
      {status, _} = Companies.update(context[:company].id, [title: "",slug: nil])
      assert status == :error
    end

    should "not update company when slug is invalid", context do
      {status, _} = Companies.update(context[:company].id, [title: nil,slug: ""] )
      assert status == :error
    end

    should "update company when update fields are valid", context  do
      {status, _} = Companies.update(context[:company].id, [title: "newTitle",slug: "newSlug"])
      assert status == :ok

      updated_user = Companies.get(context[:company].id)
      assert updated_user.title == "newTitle"
      assert updated_user.slug == "newSlug"
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

    should "not allow access to another user's company" do
      user_one = %User{ password: "one", email: "three@four.com", name: "name" }
      {:ok, saved_user_one } = Users.create(user_one)

      user_two = %User{ password: "two", email: "four@four.com", name: "name2" }
      {:ok, saved_user_two } = Users.create(user_two)

      company = %Company{ title: "two", slug: "two", user_id: saved_user_one.id }
      {:ok, saved_company } = Companies.create(company)

      assert Canada.Can.can?(saved_user_one, :read, company) == true
      assert Canada.Can.can?(saved_user_two, :read, company) == false
    end

  end
end
