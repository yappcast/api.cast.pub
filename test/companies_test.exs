defmodule CompaniesTest do
  use ExUnit.Case
  alias YappCast.Repo
  alias YappCast.Models.User
  alias YappCast.Models.Company
  alias YappCast.Queries.Users
  alias YappCast.Queries.Companies

  setup context do
    Ecto.Migrator.run(Repo, "priv/repo/migrations", :up, [all: true])

    on_exit fn ->
      Ecto.Migrator.run(Repo, "priv/repo/migrations", :down, [all: true])
    end

    user = %User{ email: "three@four.com", password: "two", name: "name" }
    {:ok, saved_user } = Users.create(user)

    { :ok, Dict.put(context, :user, saved_user) }
  end

  test "not create company when title missing", context do
    company = %Company{ slug: "two", user_id: context[:user].id }
    {status, _ } = Companies.create(company)
    assert status == :error
  end

  test "not create company when slug missing", context do
    company = %Company{ title: "two", user_id: context[:user].id }
    {status, _ } = Companies.create(company)
    assert status == :error
  end

  test "create company when all required fields are present", context do
    company = %Company{ title: "two", slug: "two", user_id: context[:user].id }
    {:ok, saved_company } = Companies.create(company)
    assert company.title == saved_company.title
    assert company.slug == saved_company.slug
  end

  test "not update company when title is invalid", context do
    company = %Company{ title: "two", slug: "two", user_id: context[:user].id }
    {:ok, saved_company } = Companies.create(company)

    {status, _} = Companies.update(saved_company.id, %{"title" => "", "slug" => nil})
    assert status == :error
  end

  test "not update company when slug is invalid", context do
    company = %Company{ title: "two", slug: "two", user_id: context[:user].id }
    {:ok, saved_company } = Companies.create(company)

    {status, _} = Companies.update(saved_company.id, %{"title" => nil, "slug" => ""} )
    assert status == :error
  end

  test "update company when update fields are valid", context  do
    company = %Company{ title: "two", slug: "two", user_id: context[:user].id }
    {:ok, saved_company } = Companies.create(company)

    {status, _} = Companies.update(saved_company.id, %{"title" => "newTitle", "slug" => "newSlug"})
    assert status == :ok

    updated_user = Companies.get(saved_company.id)
    assert updated_user.title == "newTitle"
    assert updated_user.slug == "newSlug"
  end

  test "not allow access to another user's company" do
    user_one = %User{ password: "one", email: "three3@four.com", name: "name" }
    {:ok, saved_user_one } = Users.create(user_one)

    user_two = %User{ password: "two", email: "four@four.com", name: "name2" }
    {:ok, saved_user_two } = Users.create(user_two)

    company = %Company{ title: "two", slug: "two", user_id: saved_user_one.id }
    {:ok, _saved_company } = Companies.create(company)

    assert Canada.Can.can?(saved_user_one, :read, company) == true
    assert Canada.Can.can?(saved_user_two, :read, company) == false
  end

end
