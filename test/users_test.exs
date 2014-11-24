defmodule UsersTest do
  use ShouldI
  alias YappCast.Repo
  alias YappCast.Models.User
  alias YappCast.Queries.Users

  with "creating user" do
    setup_all _context do
      Ecto.Migrator.run(Repo, "priv/repo/migrations", :up, [all: true])

      on_exit fn ->
        Ecto.Migrator.run(Repo, "priv/repo/migrations", :down, [all: true])
      end

      :ok
    end

    should "not create user when email missing" do
      user = %User{ password: "two" }
      {status, _ } = Users.create(user)
      assert status == :error
    end

    should "not create user when password missing" do
      user = %User{ email: "three@four.com", password: "", name: "name" }
      {status, _ } = Users.create(user)
      assert status == :error
    end

    should "not create user when name is missing" do
      user = %User{ email: "three@four.com", password: "two" }
      {status, _ } = Users.create(user)
      assert status == :error
    end

    should "create user when all required fields are present" do
      user = %User{ email: "three@four.com", password: "two", name: "name" }
      {:ok, saved_user } = Users.create(user)
      assert user.email == saved_user.email
      assert YappCast.Auth.check_password(user.password, saved_user.password)
    end 

  end

  with "updating user" do
    setup_all context do
      Ecto.Migrator.run(Repo, "priv/repo/migrations", :up, [all: true])

      on_exit fn ->
        Ecto.Migrator.run(Repo, "priv/repo/migrations", :down, [all: true])
      end

      user = %User{ email: "three@four.com", password: "two", name: "name" }
      {:ok, saved_user } = Users.create(user)

      { :ok, Dict.put(context, :user, saved_user) }
    end

    should "not update user when email is invalid", context do
      {status, _} = Users.update(context[:user].id, "", nil, nil)
      assert status == :error
    end

    should "not update user when password is invalid", context do
      {status, _} = Users.update(context[:user].id, nil, "", nil)
      assert status == :error
    end

    should "not update user when name is invalid", context do
      {status, _} = Users.update(context[:user].id, nil, nil, "")
      assert status == :error
    end

    should "update user when update fields are valid", context  do
      {status, _} = Users.update(context[:user].id, "update@email.com", "three", "newName")
      assert status == :ok

      updated_user = Users.get(context[:user].id)
      assert updated_user.email == "update@email.com"
      assert updated_user.name == "newName"
      assert YappCast.Auth.check_password("three", updated_user.password)
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

    should "not allow access to another user's data" do
      user_one = %User{ password: "one", email: "three@four.com", name: "name" }
      {:ok, saved_user_one } = Users.create(user_one)

      user_two = %User{ password: "two", email: "four@four.com", name: "name2" }
      {:ok, saved_user_two } = Users.create(user_two)

      assert Canada.Can.can?(saved_user_one, :read, saved_user_one) == true
      assert Canada.Can.can?(saved_user_two, :read, saved_user_one) == false
    end

  end
end
