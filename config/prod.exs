use Mix.Config

# ## SSL Support
#
# To get SSL working, you will need to set:
#
#     https: [port: 443,
#             keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#             certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables point to a file on
# disk for the key and cert.

config :phoenix, YappCast.Router,
  url: [host: "example.com"],
  http: [port: System.get_env("PORT")],
  secret_key_base: "i3j++7OMwkwxOCoO1w7hXteP5mKdHo6MHG84qG/v0mQiwKdigvY0jKzITCg//hjcvNZ7r+0vYBmC60imugip+w=="

config :logger, :console,
  level: :info

config :yapp_cast,
  database_url: "ecto://postgres@localhost/yapp_cast_prod"
