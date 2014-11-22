# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the router
config :phoenix, YappCast.Router,
  url: [host: "localhost"],
  http: [port: System.get_env("PORT")],
  https: false,
  secret_key_base: "i3j++7OMwkwxOCoO1w7hXteP5mKdHo6MHG84qG/v0mQiwKdigvY0jKzITCg//hjcvNZ7r+0vYBmC60imugip+w==",
  catch_errors: true,
  debug_errors: false,
  error_controller: YappCast.PageController

# Session configuration
config :phoenix, YappCast.Router,
  session: [store: :cookie,
            key: "_yapp_cast_key"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :yapp_cast,
  database_url: "ecto://postgres@localhost/yapp_cast_dev",
  key: "secret",
  token_expires: 3000,
  password_work_factor: 4

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
