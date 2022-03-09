defmodule Meeple.Service.User do
  @behaviour Sim.CommandHandler

  # alias Sim.Realm.SimulationLoop
  alias Meeple.{Tableau, FogOfWar, Pawn, Plan, Territory}

  @impl true
  def execute(:create, name: name) do
    :ok = Territory.create(name)
    :ok = Tableau.create(name)
    Tableau.pawns() |> Enum.each(&Territory.set_pawn(&1))
    :ok = FogOfWar.create(name)
    :ok = Plan.clear()
    [{:user, :game_created}]
  end

  def clear_plan() do
    :ok = Plan.clear()
    # ???
    [{:admin, :game_created}]
  end
end
