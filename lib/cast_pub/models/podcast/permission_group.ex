defmodule CastPub.Models.Podcast.PermissionGroup do
  use Ecto.Model
  use Vex.Struct

  schema "podcast_permission_group" do
    field :title, :string
    belongs_to :podcast, CastPub.Models.Podcast
    has_many :members, CastPub.Models.Podcast.PermissionGroupMember
  end

  validates :title, presence: true, length: [max: 255]
end