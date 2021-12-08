defmodule Meeple.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Meeple.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Meeple.PubSub}
      # Start a worker by calling: Meeple.Worker.start_link(arg)
      # {Meeple.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Meeple.Supervisor)
  end
end
