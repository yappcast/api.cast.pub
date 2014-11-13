defmodule YappCast.Models.Podcast do
  use Ecto.Model

  schema "podcasts" do
    field :name, :string
    field :slug, :string
    field :cover_url, :string
    belongs_to :company, YappCast.Models.Company
    has_many :episodes, YappCast.Models.Episode
    has_many :user_podcast_permissions, YappCast.Models.UserPodcastPermission
  end
end