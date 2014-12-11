defmodule CastPub.Endpoint do
  use Phoenix.Endpoint, otp_app: :cast_pub

  plug Plug.Static,
    at: "/", from: :cast_pub

  plug Plug.Logger

  # Code reloading will only work if the :code_reloader key of
  # the :phoenix application is set to true in your config file.
  plug Phoenix.CodeReloader

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

#  plug Plug.Session,
#    store: :cookie,
#    key: "_cast_pub_key",
#    signing_salt: "<%= signing_salt %>",
#    encryption_salt: "<%= encryption_salt %>"

  plug PlugCors, headers: ["Authorization", "Content-Type"]

  plug :router, CastPub.Router
end
