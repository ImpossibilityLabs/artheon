# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :artheon,
  ecto_repos: [Artheon.Repo]

# Configures the endpoint
config :artheon, Artheon.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VTwQhimVf6yhdqql5mCFzezTRQDzlbyh/smr6EaSGuY1lzB2WAOuqNPHzRAobQI7",
  render_errors: [view: Artheon.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Artheon.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure Artsy
config :artsy, Artsy,
  url: {:system, "ARTSY_API_URL"},
  client_id: {:system, "ARTSY_CLIENT_ID"},
  client_secret: {:system, "ARTSY_CLIENT_SECRET"}

# Configure your database
config :artheon, Artheon.Repo,
  adapter: Ecto.Adapters.MySQL,
  hostname: System.get_env("MYSQL_HOSTNAME") || "",
  username: System.get_env("MYSQL_USERNAME") || "",
  password: System.get_env("MYSQL_PASSWORD") || "",
  database: System.get_env("MYSQL_DATABASE") || "",
  pool_size: 20

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
