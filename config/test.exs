use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :takso, TaksoWeb.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :takso, Takso.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "root",
  database: "takso_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :hound, driver: "chrome_driver"
config :takso, sql_sandbox: true
