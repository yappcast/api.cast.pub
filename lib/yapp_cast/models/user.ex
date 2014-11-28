defmodule YappCast.Models.User do
  use Ecto.Model
  use Vex.Struct

  schema "users" do
    field :email, :string
    field :password, :string
    field :name, :string
    has_many :podcasts, YappCast.Models.Podcast
    has_many :user_podcast_permissions, YappCast.Models.UserPodcastPermission
  end

  validates :email, presence: true, length: [max: 255]
  validates :password, presence: true
  validates :name, presence: true, length: [max: 255]
end