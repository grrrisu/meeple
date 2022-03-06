defmodule Meeple.BoardSupervisor do
  use Supervisor

  alias Sim.Realm.SimulationLoop
  alias Meeple.{Tableau, FogOfWar, GameSession, Plan, Territory}

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    children = [
      Territory,
      Tableau,
      FogOfWar,
      Plan,
      SimulationLoop,
      GameSession
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end
