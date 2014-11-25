defmodule YappCast.Models.Podcast.Category do
  use Ecto.Model
  use Vex.Struct

  schema "podcast_categories" do
    belongs_to :podcast, YappCast.Models.Podcast
    belongs_to :category, YappCast.Models.Category
    has_many :sub_categories, YappCast.Models.Podcast.SubCategory
  end

  validates :title, presence: true, length: [max: 255]
end