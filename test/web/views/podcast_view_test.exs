defmodule PodcastViewTest do
  use ExUnit.Case

  test "escape string" do
    str = "a normal string"
    assert YappCast.PodcastView.escape_string(str) == str

    str = "Law & Order"
    assert YappCast.PodcastView.escape_string(str) == "Law &amp; Order"

    str = "Law & Order >"
    assert YappCast.PodcastView.escape_string(str) == "Law &amp; Order &gt;" 

    str = "Law < Order' \""
    assert YappCast.PodcastView.escape_string(str) == "Law &lt; Order&apos; &quot;"   
  end
end