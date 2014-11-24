defmodule YappCast.Models.SubCategory do
  use Ecto.Model
  use Vex.Struct

  schema "sub_categories" do
    field :title, :string
    belongs_to :category, YappCast.Models.Category
  end

  validates :title, presence: true, length: [max: 255]
end