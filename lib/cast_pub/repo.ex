defmodule CastPub.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres, env: Mix.env

  @doc "Adapter configuration"
  def conf do
    parse_url Application.get_env(:yapp_cast, :database_url)
  end

  @doc "The priv directory to load migrations and metadata."
  def priv do
    app_dir(:yapp_cast, "priv/repo")
  end
end
