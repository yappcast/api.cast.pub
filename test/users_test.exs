defmodule UsersTest do
  use ShouldI
  alias YappCast.Repo
  alias YappCast.Models.User
  alias YappCast.Queries.Users

  with "database" do

    setup context do
      Ecto.Migrator.run(Repo, "priv/repo/migrations", :up, [all: true])

      on_exit fn ->
        Ecto.Migrator.run(Repo, "priv/repo/migrations", :down, [all: true])
      end

      context
    end

    should "create user" do
      user = %User{ username: "one", password: "two", email: "three@four.com" }
      saved_user = Users.create(user)
      assert user.username == saved_user.username
    end

  end
end
