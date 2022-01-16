defmodule Meeple.FogOfWar do
  use Agent

  alias Sim.Grid
  alias Meeple.Territory

  alias Meeple.Territory.One
  alias Meeple.Territory.Test, as: TestTerritory

  def start_link(args \\ []) do
    Agent.start_link(
      fn -> %{territory: args[:territory] || Territory, grid: nil} end,
      name: args[:name] || __MODULE__
    )
  end

  def create(name, pid \\ __MODULE__) do
    Agent.get_and_update(pid, fn state ->
      grid = create_grid(name)
      {:ok, %{state | grid: grid}}
    end)
  end

  def field(x, y, pid \\ __MODULE__) do
    Agent.get(pid, fn %{territory: territory, grid: grid} ->
      visability = Grid.get(grid, x, y)
      get_field(x, y, visability, territory)
    end)
  end

  def discover(x, y, pid \\ __MODULE__) do
    Agent.get_and_update(pid, fn %{territory: territory, grid: grid} = state ->
      new_fog = Grid.put(grid, x, y, 5)
      field = get_field(x, y, 5, territory)
      {field, %{state | grid: new_fog}}
    end)
  end

  defp create_grid("test"), do: create_grid(TestTerritory, 3, 4)
  defp create_grid("one"), do: create_grid(One, 15, 7)

  defp create_grid(module, width, height) when is_atom(module) do
    Grid.create(width, height, &module.create_fog/2)
  end

  defp get_field(x, y, visability, territory) do
    case visability do
      5 -> Territory.field(x, y, territory)
      1 -> %{vegetation: Territory.field(x, y, territory) |> Map.get(:vegetation)}
      0 -> %{}
    end
  end
end
