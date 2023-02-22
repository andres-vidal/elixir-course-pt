import Config

config :tarefas,
  uuid: &Tarefas.Application.empty_string/0,
  file: "tarefas_test.txt"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :tarefas, TarefasWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "GRWf0qV+dIhuoCZSnwcokxXdU3AsePGf5rsSECH36s0xRZse4lOJkxSb6zPiaOZA",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
