defmodule Mix.Tasks.Yapp.Seed.Categories do
  use Mix.Task
  alias CastPub.Queries.Categories

  @shortdoc "Seeds the Categories"

  @moduledoc """
  Seeds the Categories.
  https://itunes.apple.com/us/genre/podcasts/id26

  ## Command line options

  * `--no-start` - do not start applications

  ## Examples

      mix yapp.seed.categories

  """
  def run(args) do
    Mix.Task.run "app.start", args

    Categories.seed

    Mix.shell.info "Categories seeded"
  end
end
