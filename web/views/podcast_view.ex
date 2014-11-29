defmodule YappCast.PodcastView do
  use YappCast.View

  def get_episode_guid(podcast_id, episode_id) do
    scheme_and_port = YappCast.Router.Helpers.url(YappCast.Router)
    "#{scheme_and_port}/#{podcast_id}/#{episode_id}"
  end

  def get_episode_url(podcast_id, episode_id, file_name) do
    scheme_and_port = YappCast.Router.Helpers.url(YappCast.Router)
    path = YappCast.Router.Helpers.episode_path(:download, podcast_id, episode_id, file_name)
    "#{scheme_and_port}#{path}"
  end

  def encode_date(date) do
    Timex.DateFormat.format!(date, "{RFC1123}")
  end
  

end
