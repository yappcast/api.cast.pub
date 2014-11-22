defmodule YappCast.Models.Episode do
  use Ecto.Model
  use Vex.Struct

  schema "episodes" do
    field :name, :string
    field :slug, :string
    field :cover_url, :string
    field :media_url, :string
    field :published, :boolean
    belongs_to :podcast, YappCast.Models.Podcast
  end

  validates :name, presence: true, length: [max: 255]
  validates :slug, presence: true, length: [max: 255]
end