defmodule CastPub.Models.Podcast.SubCategory do
  use Ecto.Model
  use Vex.Struct

  schema "podcast_sub_categories" do
    belongs_to :podcast_category, CastPub.Models.Podcast.Category
    belongs_to :sub_category, CastPub.Models.SubCategory
  end
end