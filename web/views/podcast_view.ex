defmodule CastPub.PodcastView do
  use CastPub.View

  def get_episode_guid(podcast_id, episode_id) do
    base_url = CastPub.Endpoint.url("/")
    "#{base_url}#{podcast_id}/#{episode_id}"
  end

  def get_episode_url(podcast_id, episode_id, file_name) do
    path = CastPub.Router.Helpers.episode_path(:download, podcast_id, episode_id, file_name)
    CastPub.Endpoint.url(path)
  end

  def encode_date(date) do
    ecto_to_timex(date)
    |> Timex.DateFormat.format!("{RFC1123}")
  end

  def ecto_to_timex(date) do
    timex_date = {date.year, date.month, date.day}
    timex_time = {date.hour, date.min, date.sec}
    Timex.Date.from({timex_date,timex_time}, Timex.Date.timezone("GMT"))
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

  def output_tag(true, tag) do
    "<#{tag}>yes</#{tag}>"
  end

  def output_tag(false, tag) do
    "<#{tag}>no</#{tag}>"
  end

  def output_tag(nil, _tag) do
    ""
  end

  def output_tag(value, tag) do
    "<#{tag}>#{escape_string(value)}</#{tag}>"
  end

  def output_tag(nil, _tag, _) do
    ""
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

  def output_category(category) do


    actual_category = CastPub.Queries.Categories.get(category.category_id)

    if actual_category.category_id == nil do
      "<itunes:category text=\"#{escape_string(actual_category.title)}\"/>"
    else
      parent_catgory = CastPub.Queries.Categories.get(actual_category.category_id)
      inner_xml = "<itunes:category text=\"#{escape_string(actual_category.title)}\"/>"
      "<itunes:category text=\"#{escape_string(parent_catgory.title)}\">#{inner_xml}</itunes:category>"
    end
  end
  
  def output_category(category, sub_categories) do
    subcategories = Enum.map(sub_categories, fn(x) -> output_category(x, []) end)
    |> Enum.join
    "<itunes:category text=\"#{escape_string(category.title)}\">#{subcategories}</itunes:category>"
  end

  def output_episode_link_and_enclosure(episode) do
    case episode.media_url do
      nil ->
        ""
      _ ->
        url = get_episode_url(episode.podcast_id, episode.id, episode.file_name)
        |> escape_string

        link = "<link>#{escape_string(url)}</link>"
        enclosure = "<enclosure url=\"#{url}\" length=\"#{episode.media_content_length}\" type=\"#{episode.media_mime_type}\"/>"

        link <> enclosure
    end
  end

  def output_guid(episode) do
    guid = get_episode_guid(episode.podcast_id, episode.id) |> escape_string
    "<guid isPermaLink=\"false\">#{guid}</guid>"
  end

end
