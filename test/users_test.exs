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

  test "create user" do
    user = %User{ password: "two" }
    {status, saved_user } = Users.create(user)
    assert status == :error

    user = %User{ password: "two", email: "three@four.com" }
    {:ok, saved_user } = Users.create(user)
    assert user.email == saved_user.email
  end

  test "user permissions" do
    user = %User{ password: "two", email: "three@four.com" }
    {:ok, saved_user } = Users.create(user)

    assert Canada.Can.can?(saved_user, :get, saved_user) == true
  end
end
