defimpl Canada.Can, for: YappCast.Models.User do
  def can?(user, action, %YappCast.Models.User{id: id}) when action in [:read, :create, :update, :delete] do
    user.id == id
  end

  def can?(user, action, podcast = %YappCast.Models.Podcast{}) when action in [:read, :create, :update, :delete] do
    user.id == podcast.user_id
  end

  def can?(user, action, episode = %YappCast.Models.Episode{}) when action in [:read, :create, :update, :delete] do
    podcast = YappCast.Queries.Podcasts.get(episode.podcast_id)
    user.id == podcast.user_id
  end
end