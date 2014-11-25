defmodule YappCast.Models.Podcast.PermissionGroupMember do
  use Ecto.Model

  schema "podcast_permission_group_member" do
    belongs_to :group, YappCast.Models.Podcast.PermissionGroup
    belongs_to :user, YappCast.Models.User
  end
end