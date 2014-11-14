defmodule UsersTest do
  use ExUnit.Case
  alias YappCast.Repo
  alias YappCast.Models.User
  alias YappCast.Queries.Users

  @migration_directory "priv/repo/migrations"

  setup do
    Ecto.Migrator.run(Repo, @migration_directory, :up, [all: true])

    on_exit fn ->
      Ecto.Migrator.run(Repo, @migration_directory, :down, [all: true])
    end

    :ok
  end

  test "create user" do
    user = %User{ username: "one", password: "two", email: "three@four.com" }
    saved_user = Users.create(user)
    assert user.username == saved_user.username
  end
end
