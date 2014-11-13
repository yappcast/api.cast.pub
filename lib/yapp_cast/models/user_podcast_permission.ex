defmodule YappCast.Models.UserPodcastPermission do
  use Ecto.Model

  schema "user_podcast_permissions" do
    belongs_to :user, YappCast.Models.User
    belongs_to :podcast, YappCast.Models.Podcast
    field :can_add, :boolean
    field :can_edit, :boolean
    field :can_view, :boolean
    field :can_delete, :boolean
  end
end