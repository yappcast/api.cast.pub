defmodule CastPub.Models.Category do
  use Ecto.Model
  use Vex.Struct

  schema "categories" do
    field :title, :string
    belongs_to :category, CastPub.Models.Category
    has_many :categories, CastPub.Models.Category
  end

  validates :title, presence: true, length: [max: 255]
end