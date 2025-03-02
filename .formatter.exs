[
  import_deps: [:ecto, :ecto_sql, :phoenix, :typed_struct],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"],
  plugins: [Styler, Phoenix.LiveView.HTMLFormatter],
  subdirectories: ["priv/*/migrations"]
]
