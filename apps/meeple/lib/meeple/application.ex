defmodule Meeple.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Meeple.Repo,
      {Phoenix.PubSub, name: Meeple.PubSub},
      Meeple.BoardSupervisor,
      {
        Sim.Realm.Supervisor,
        name: MeepleRealm,
        domain_services: [
          {Meeple.Service.Admin, partition: :admin, max_demand: 1},
          {Meeple.Service.User, partition: :user, max_demand: 1},
          {Meeple.Service.Sim, partition: :sim, max_demand: 1}
        ],
        reducers: [Meeple.PubSubReducer]
      }
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Meeple.Supervisor)
  end
end
