import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :meeple, Meeple.Repo,
  # username: "postgres",
  # password: "postgres",
  database: "meeple_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

if System.get_env("GITHUB_ACTIONS") do
  config :meeple, Meeple.Repo,
    username: "postgres",
    password: "postgres"
end

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :meeple_web, MeepleWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "/4qpqkdNaoCuhYuTH0N+DWF63NhNfvlqJvcYn9qKhRkh6rSzHyXHk0ZyKT3xVv6k",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# In test we don't send emails.
config :meeple, Meeple.Mailer, adapter: Swoosh.Adapters.Test

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
