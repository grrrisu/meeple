defmodule Meeple.FogOfWar do
  use Agent

  alias Sim.Grid
  alias Meeple.Territory

  alias Meeple.Territory.One
  alias Meeple.Territory.Test, as: TestTerritory

  def start_link(args) do
    Agent.start_link(fn -> nil end, name: args[:name] || __MODULE__)
  end

  def create(name, pid \\ __MODULE__) do
    Agent.get_and_update(pid, fn _ ->
      state = create_grid(name)
      {:ok, state}
    end)
  end

  def field(x, y, pid \\ __MODULE__) do
    Agent.get(pid, fn grid ->
      visability = Grid.get(grid, x, y)
      get_field(x, y, visability)
    end)
  end

  def discover(x, y, pid \\ __MODULE__) do
    Agent.get_and_update(pid, fn grid ->
      new_fog = Grid.put(grid, x, y, 5)
      field = get_field(x, y, 5)
      {field, new_fog}
    end)
  end

  defp create_grid("test"), do: create_grid(TestTerritory, 3, 4)
  defp create_grid("one"), do: create_grid(One, 15, 7)

  defp create_grid(module, width, height) when is_atom(module) do
    Grid.create(width, height, &module.create_fog/2)
  end

  defp get_field(x, y, visability) do
    case visability do
      5 -> Territory.field(x, y)
      1 -> %{vegetation: Territory.field(x, y) |> Map.get(:vegetation)}
      0 -> %{}
    end
  end
end
