defmodule YappCast.PodcastView do
  use YappCast.View

  def get_episode_guid(podcast_id, episode_id) do
    scheme_and_port = Phoenix.Router.Helpers.url(YappCast.Router)
    "#{scheme_and_port}/#{podcast_id}/#{episode_id}"
  end

  def get_episode_url(podcast_id, episode_id, file_name) do
    scheme_and_port = Phoenix.Router.Helpers.url(YappCast.Router)
    path = YappCast.Router.Helpers.episode_path(:download, podcast_id, episode_id, file_name)
    "#{scheme_and_port}#{path}"
  end

  def encode_date(date) do
    Timex.DateFormat.format!(date, "{RFC1123}")
  end

  def escape_string(str) do
    case str do
      nil ->
        ""
      _ ->
        str
        |> String.replace("&", "&amp;")
        |> String.replace("<", "&lt;")
        |> String.replace(">", "&gt;")
        |> String.replace("'", "&apos;")
        |> String.replace("\"", "&quot;")
    end
  end

  def output_tag(value, tag) do
    "<#{tag}>#{escape_string(value)}</#{tag}>"
  end

  def output_tag(value, tag, :cdata) do
    "<#{tag}><![CDATA[#{escape_string(value)}]]></#{tag}>"
  end

  def output_tag(value, tag, :date) do
    "<#{tag}>#{escape_string(encode_date(value))}</#{tag}>"
  end

  def output_tag(value, tag, :image) do
    "<#{tag} href=\"#{escape_string(value)}\"/>"
  end

  def output_tag(true, tag) do
    "<#{tag}>yes</#{tag}>"
  end

  def output_tag(false, tag) do
    "<#{tag}>no</#{tag}>"
  end

  def output_tag(nil, tag) do
    ""
  end

  def output_category(category, []) do
    "<itunes:category text=\"#{escape_string(category.get.category.title)}\"/>"
  end
  
  def output_category(category, sub_categories) do
    subcategories = Enum.map(sub_categories, fn(x) -> output_category(x, []) end)
    |> Enum.join
    "<itunes:category text=\"#{escape_string(category.get.category.title)}\">#{subcategories}</itunes:category>"
  end

  def output_episode_link(episode) do
    if episode.media_url do
      nil ->
        ""
      media_url ->
        url = get_episode_url(episode.podcast_id, episode.id, episode.file_name)
        |> escape_string

        link = "<link>#{escape_string(url)}</link>"
        enclosure = "<enclosure url=\"#{url}\" length=\"#{episode.media_length}\" type=\"#{episode.media_mime_type}\"/>"

        link <> enclosure
    end
  end

  def output_guid(episode) do
    guid = get_episode_guid(episode.podcast_id, episode.id) |> escape_string
    "<guid isPermaLink=\"false\">#{guid}</guid>"
  end

end
