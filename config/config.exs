# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :menu,
  ecto_repos: [Menu.Repo]

# Configures the endpoint
config :menu, MenuWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0Y6y6aEkIA6J1QsUcF3GV3108IxVscrPDAzlUFioZcE49Eihaz1qfM+gRvCNZzkN",
  render_errors: [view: MenuWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Menu.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
