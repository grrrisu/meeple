defmodule Meeple.Service.User do
  @behaviour Sim.CommandHandler

  # alias Sim.Realm.SimulationLoop
  alias Meeple.Board

  def execute(:clear_plan, []) do
    Board.clear_plan()
    [{:plan_updated, :cleared}]
  end
end
