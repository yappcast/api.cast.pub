defmodule Mix.Tasks.Castpub.Seed do
  use Mix.Task
  alias CastPub.Queries.Categories

  @shortdoc "Seeds the Database"

  @moduledoc """
  Seeds the Database

  ## Command line options

  * `--no-start` - do not start applications

  ## Examples

      mix castpub.seed

  """
  def run(args) do
    Mix.Task.run "app.start", args

    Categories.seed
    Mix.shell.info "Categories seeded"
  end
end
