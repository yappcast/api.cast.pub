defmodule CastPub.Models.Episode do
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
    field :media_url, :string
    field :media_content_length, :integer
    field :media_mime_type, :string
    field :file_name, :string
    belongs_to :podcast, CastPub.Models.Podcast
  end

  validates :title, presence: true, length: [max: 255]
end