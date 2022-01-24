defmodule Meeple.Board do
  @moduledoc """
  Context for BoardLiveView and its components
  """

  alias Meeple.{FogOfWar, Plan, Territory}

  def create(name) do
    :ok = FogOfWar.create(name)
    :ok = Territory.create(name)
    Plan.clear()
  end

  def map_exists?() do
    Territory.exists?()
  end

  def map_dimensions() do
    Territory.dimensions()
  end

  def get_field(x, y, true), do: FogOfWar.field(x, y)
  def get_field(x, y, false), do: Territory.field(x, y)

  def add_action(action) do
    Plan.add_action(action)
  end
end
