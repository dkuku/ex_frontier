[
  import_deps: [:assert_value],
  inputs: ["*.{ex,exs}", "{config,lib,test}/**/*.{ex,exs}"],
  plugins: [Styler],
  subdirectories: ["priv/*/migrations"]
]
