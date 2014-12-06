defmodule CastPub.Models.Podcast.Category do
  use Ecto.Model
  use Vex.Struct

  schema "podcast_categories" do
    belongs_to :podcast, CastPub.Models.Podcast
    belongs_to :category, CastPub.Models.Category
    has_many :sub_categories, CastPub.Models.Podcast.SubCategory
  end

end