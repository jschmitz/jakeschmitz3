use Mix.Config

# Configure your database
config :jakeschmitz3, Jakeschmitz3.Repo,
  username: "postgres",
  password: "postgres",
  database: "jakeschmitz3_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :jakeschmitz3, Jakeschmitz3Web.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
