defmodule CastPub.Models.Podcast.PermissionGroupMember do
  use Ecto.Model

  schema "podcast_permission_group_member" do
    belongs_to :group, CastPub.Models.Podcast.PermissionGroup
    belongs_to :user, CastPub.Models.User
  end
end