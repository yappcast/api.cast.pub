defmodule YappCast.Models.Podcast do
  use Ecto.Model
  use Vex.Struct

  schema "podcasts" do
    field :name, :string
    field :slug, :string
    field :cover_url, :string
    belongs_to :company, YappCast.Models.Company
    has_many :episodes, YappCast.Models.Episode
    has_many :user_podcast_permissions, YappCast.Models.UserPodcastPermission
  end

  validates :name, presence: true, length: [max: 255]
  validates :slug, presence: true, length: [max: 255]
end