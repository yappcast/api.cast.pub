defmodule YappCast.Models.PodcastPermissionGroupMember do
  use Ecto.Model

  schema "podcast_permission_group_member" do
    belongs_to :group, YappCast.Models.PodcastPermissionGroup
    belongs_to :user, YappCast.Models.User
  end
end