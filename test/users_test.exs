defmodule UsersTest do
  use ExUnit.Case
  alias YappCast.Repo
  alias YappCast.Models.User
  alias YappCast.Queries.Users

  setup do
      Ecto.Migrator.run(Repo, "priv/repo/migrations", :up, [all: true])

      on_exit fn ->
        Ecto.Migrator.run(Repo, "priv/repo/migrations", :down, [all: true])
      end

      :ok
  end

  test "create user with no email" do
    user = %User{ password: "two" }
    {status, _ } = Users.create(user)
    assert status == :error
  end

  test "create user with no password" do
    user = %User{ email: "three@four.com", password: "" }
    {status, _ } = Users.create(user)
    assert status == :error
  end

  test "create valid user" do
    user = %User{ email: "three@four.com", password: "two" }
    {:ok, saved_user } = Users.create(user)
    assert user.email == saved_user.email
    assert YappCast.Auth.check_password(user.password, saved_user.password)
  end

  test "update user with no email" do
    user = %User{ email: "three@four.com", password: "two" }
    {:ok, saved_user } = Users.create(user)

    {status, _} = Users.update(saved_user.id, "", nil)
    assert status == :error
  end

  test "update user with no password" do
    user = %User{ email: "three@four.com", password: "two" }
    {:ok, saved_user } = Users.create(user)

    {status, _} = Users.update(saved_user.id, nil, "")
    assert status == :error
  end

  test "update user" do
    user = %User{ email: "three@four.com", password: "two" }
    {:ok, saved_user } = Users.create(user)

    {status, _} = Users.update(saved_user.id, "update@email.com", "three")
    assert status == :ok

    updated_user = Users.get(saved_user.id)
    assert updated_user.email == "update@email.com"
    assert YappCast.Auth.check_password("three", updated_user.password)
  end

  test "user permissions" do
    user_one = %User{ password: "one", email: "three@four.com" }
    {:ok, saved_user_one } = Users.create(user_one)

    user_two = %User{ password: "two", email: "four@four.com" }
    {:ok, saved_user_two } = Users.create(user_two)

    assert Canada.Can.can?(saved_user_one, :read, saved_user_one) == true
    assert Canada.Can.can?(saved_user_two, :read, saved_user_one) == false
  end
end
