defimpl Canada.Can, for: YappCast.Models.User do
  def can?(user, action, %YappCast.Models.User{id: id}) when action in [:read, :create, :update, :delete] do
    user.id == id
  end

  def can?(user, action, %YappCast.Models.Company{user_id: user_id}) when action in [:read, :create, :update, :delete] do
    user.id == user_id
  end

  def can?(user, action, podcast = %YappCast.Models.Podcast{}) when action in [:read, :create, :update, :delete] do
    company = YappCast.Queries.Companies.get(podcast.company_id)
    user.id == company.user_id
  end

  def can?(user, action, episode = %YappCast.Models.Episode{}) when action in [:read, :create, :update, :delete] do
    podcast = YappCast.Queries.Podcasts.get(episode.podcast_id)
    company = YappCast.Queries.Companies.get(podcast.company_id)
    user.id == company.user_id
  end
end