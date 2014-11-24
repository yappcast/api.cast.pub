defmodule YappCast.Models.PodcastCategory do
  use Ecto.Model
  use Vex.Struct

  schema "podcast_categories" do
    belongs_to :podcast, YappCast.Models.Podcast
    belongs_to :category, YappCast.Models.Category
    has_many :sub_categories, YappCast.Models.PodcastSubCategory
  end

  validates :title, presence: true, length: [max: 255]
end