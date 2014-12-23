defimpl Canada.Can, for: CastPub.Models.User do
  def can?(user, action, %CastPub.Models.User{id: id}) when action in [:read, :create, :update, :delete] do
    user.id == id
  end

  def can?(_user, :create, %CastPub.Models.Podcast{}) do
    true
  end

  def can?(user, action, podcast = %CastPub.Models.Podcast{}) when action in [:read, :update, :delete] do
    user.id == podcast.user_id
  end

  def can?(user, action, episode = %CastPub.Models.Episode{}) when action in [:read, :create, :update, :delete] do
    podcast = CastPub.Queries.Podcasts.get(episode.podcast_id)
    user.id == podcast.user_id
  end
end