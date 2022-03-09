defmodule Meeple.Service.Admin do
  @behaviour Sim.CommandHandler

  alias Meeple.{Tableau, FogOfWar, Plan, Territory}

  def execute(:create, name: name) do
    :ok = Territory.create(name)
    :ok = Tableau.create(name)
    Tableau.pawns() |> Enum.each(&Territory.set_pawn(&1))
    :ok = FogOfWar.create(name)
    :ok = Plan.clear()
    [{:game_created, name: name}]
  end
end
