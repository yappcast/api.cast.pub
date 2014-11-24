defmodule YappCast.Models.PodcastPermissionGroup do
  use Ecto.Model
  use Vex.Struct

  schema "podcast_permission_group" do
    field :title, :string
    belongs_to :podcast, YappCast.Models.Podcast
    has_many :members, YappCast.Models.PodcastPermissionGroupMember
  end

  validates :title, presence: true, length: [max: 255]
end