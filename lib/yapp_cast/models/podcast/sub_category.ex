defmodule YappCast.Models.Podcast.SubCategory do
  use Ecto.Model
  use Vex.Struct

  schema "podcast_sub_categories" do
    belongs_to :podcast_category, YappCast.Models.Podcast.Category
    belongs_to :sub_category, YappCast.Models.SubCategory
  end

  validates :title, presence: true, length: [max: 255]
end