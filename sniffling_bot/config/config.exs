import Config

config :tentacat, :extra_headers, [
  {"Content-Type", "application/json"},
  {"Accept", "application/vnd.github.v3+json"}
]

import_config "#{config_env()}.exs"
