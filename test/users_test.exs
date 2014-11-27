defmodule UsersTest do
  use ExUnit.Case
  alias YappCast.Repo
  alias YappCast.Models.User
  alias YappCast.Queries.Users

  setup _context do
    Ecto.Migrator.run(Repo, "priv/repo/migrations", :up, [all: true])

    on_exit fn ->
      Ecto.Migrator.run(Repo, "priv/repo/migrations", :down, [all: true])
    end

    :ok
  end

  test "not create user when email missing" do
    user = %User{ password: "two" }
    {status, _ } = Users.create(user)
    assert status == :error
  end

  test "not create user when password missing" do
    user = %User{ email: "three@four.com", password: "", name: "name" }
    {status, _ } = Users.create(user)
    assert status == :error
  end

  test "not create user when name is missing" do
    user = %User{ email: "three@four.com", password: "two" }
    {status, _ } = Users.create(user)
    assert status == :error
  end

  test "create user when all required fields are present" do
    user = %User{ email: "three@four.com", password: "two", name: "name" }
    {:ok, saved_user } = Users.create(user)
    assert user.email == saved_user.email
    assert YappCast.Auth.check_password(user.password, saved_user.password)
  end 

  test "not update user when email is invalid", _context do
    user = %User{ email: "three@four.com", password: "two", name: "name" }
    {:ok, saved_user } = Users.create(user)

    {status, _} = Users.update(saved_user.id, "", nil, nil)
    assert status == :error
  end

  test "not update user when password is invalid", _context do
    user = %User{ email: "three@four.com", password: "two", name: "name" }
    {:ok, saved_user } = Users.create(user)

    {status, _} = Users.update(saved_user.id, nil, "", nil)
    assert status == :error
  end

  test "not update user when name is invalid", _context do
    user = %User{ email: "three@four.com", password: "two", name: "name" }
    {:ok, saved_user } = Users.create(user)

    {status, _} = Users.update(saved_user.id, nil, nil, "")
    assert status == :error
  end

  test "update user when update fields are valid", _context  do
    user = %User{ email: "three@four.com", password: "two", name: "name" }
    {:ok, saved_user } = Users.create(user)

    {status, _} = Users.update(saved_user.id, "update@email.com", "three", "newName")
    assert status == :ok

    updated_user = Users.get(saved_user.id)
    assert updated_user.email == "update@email.com"
    assert updated_user.name == "newName"
    assert YappCast.Auth.check_password("three", updated_user.password)
  end

  test "not allow access to another user's data" do
    user_one = %User{ password: "one", email: "three@four.com", name: "name" }
    {:ok, saved_user_one } = Users.create(user_one)

    user_two = %User{ password: "two", email: "four@four.com", name: "name2" }
    {:ok, saved_user_two } = Users.create(user_two)

    assert Canada.Can.can?(saved_user_one, :read, saved_user_one) == true
    assert Canada.Can.can?(saved_user_two, :read, saved_user_one) == false
  end

end
