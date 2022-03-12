defmodule Meeple.Board do
  @moduledoc """
  Context for BoardLiveView and its components
  """
  alias Sim.Realm.SimulationLoop
  alias Meeple.{Tableau, FogOfWar, Pawn, Plan, Territory}

  def map_exists?() do
    Territory.exists?()
  end

  def map_dimensions() do
    Territory.dimensions()
  end

  def get_grid(true), do: FogOfWar.get()
  def get_grid(false), do: Territory.get()

  def get_field(x, y, true), do: FogOfWar.field(x, y)
  def get_field(x, y, false), do: Territory.field(x, y)

  def discover_field(x, y), do: FogOfWar.discover(x, y)

  def update_fog_of_war(), do: FogOfWar.update_grid()

  def get_pawns() do
    Tableau.pawns()
  end

  def get_pawn(id) do
    Tableau.get_pawn(id)
  end

  def move_pawn(pawn, x, y) do
    pawn = Territory.move_pawn(pawn, x, y)
    Tableau.update_pawn(pawn)
  end

  def add_action(%Pawn{} = pawn, action, opts) do
    Plan.add_action(pawn, action, opts)
  end

  def clear_plan() do
    Plan.clear()
  end

  def get_hour() do
    Tableau.hour()
  end

  def next_hour() do
    Plan.tick()
    Tableau.inc_hour()
  end

  def start_day() do
    SimulationLoop.start(1_000, fn ->
      if next_hour() < 11 do
        :ok
      else
        clear_plan()
        :stop
      end
    end)
  end

  def stop_day() do
    SimulationLoop.stop()
  end

  def running?() do
    SimulationLoop.running?()
  end
end
