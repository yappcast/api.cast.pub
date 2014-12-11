defmodule CastPub.Repo.Migrations.Seed do
  use Ecto.Migration

  def up do
    CastPub.Queries.Categories.seed
    ""
  end

  def down do
    Enum.each(CastPub.Queries.Categories.list,
      fn(x) -> 
        #only delete the top level categorie. The others will delete by cascading
        if x.category_id == nil do
          CastPub.Queries.Categories.delete(x.id) 
        end
      end
    )
    ""
  end
end
