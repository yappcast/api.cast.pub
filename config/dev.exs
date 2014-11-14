use Mix.Config

config :phoenix, YappCast.Router,
  http: [port: System.get_env("PORT") || 4000],
  debug_errors: true

# Enables code reloading for development
config :phoenix, :code_reloader, true

config :yapp_cast,
  database_url: "ecto://postgres@localhost/yapp_cast_dev"
