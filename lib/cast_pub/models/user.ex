defmodule CastPub.Models.User do
  use Ecto.Model
  use Vex.Struct

  schema "users" do
    field :email, :string
    field :password, :string
    field :name, :string
    has_many :podcasts, CastPub.Models.Podcast
    has_many :podcast_permission_group_members, CastPub.Models.Podcasts.PermissionGroupMember
  end

  validates :email, presence: true, length: [max: 255]
  validates :password, presence: true
  validates :name, presence: true, length: [max: 255]
end