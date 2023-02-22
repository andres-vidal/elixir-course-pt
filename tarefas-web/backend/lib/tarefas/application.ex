defmodule Tarefas.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TarefasWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Tarefas.PubSub},
      # Start the Endpoint (http/https)
      TarefasWeb.Endpoint
      # Start a worker by calling: Tarefas.Worker.start_link(arg)
      # {Tarefas.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tarefas.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TarefasWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def empty_string(), do: ""
end
