use Mix.Config

config :phoenix, YappCast.Router,
  http: [port: System.get_env("PORT") || 4001],
  catch_errors: false

config :yapp_cast,
  database_url: "ecto://postgres@localhost/yapp_cast_test?size=1&max_overflow=0"
