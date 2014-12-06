defmodule CastPub.Models.Category do
  use Ecto.Model
  use Vex.Struct

  schema "categories" do
    field :title, :string
    has_many :sub_categories, CastPub.Models.SubCategory
  end

  validates :title, presence: true, length: [max: 255]
end