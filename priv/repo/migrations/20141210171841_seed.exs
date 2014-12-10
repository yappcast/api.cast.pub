defmodule CastPub.Repo.Migrations.Seed do
  use Ecto.Migration

  def up do
    CastPub.Queries.Categories.seed
    ""
  end

  def down do
    Enum.each(CastPub.Queries.Categories.list, 
      fn(x) -> CastPub.Queries.Categories.delete(x.id) end
    )
    ""
  end
end
