defmodule YappCast.Models.Episode do
  use Ecto.Model
  use Vex.Struct

  schema "episodes" do
    field :title, :string
    field :publish_date, :datetime
    field :author, :string
    field :block, :boolean, default: false
    field :image_url, :string
    field :duration, :string
    field :explicit, :boolean, default: false
    field :is_closed_captioned, :boolean, default: false
    field :order, :integer
    field :subtitle, :string
    field :summary, :string
    field :slug, :string
    field :media_url, :string
    belongs_to :podcast, YappCast.Models.Podcast
  end

  validates :title, presence: true, length: [max: 255]
  validates :slug, presence: true, length: [max: 255]
end