defmodule Meeple.Board do
  @moduledoc """
  Context for BoardLiveView and its components
  """

  alias Meeple.{Tableau, FogOfWar, Plan, Territory}

  def create(name) do
    :ok = Territory.create(name)
    :ok = Tableau.create(name)
    Tableau.pawns() |> Enum.each(&Territory.set_pawn(&1))
    :ok = FogOfWar.create(name)
    clear_plan()
  end

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

  def get_pawn(id) do
    Tableau.get_pawn(id)
  end

  def move_pawn(pawn, x, y) do
    pawn = Territory.move_pawn(pawn, x, y)
    Tableau.update_pawn(pawn)
  end

  def add_action(action) do
    Plan.add_action(action)
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
end
