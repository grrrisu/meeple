defmodule Meeple.FogOfWar do
  @moduledoc """
  Fog of war, shows only the parts of the territory to the player, that are visible to him/her.
  It also combines information from the territory with player specific informations.

  state:
  territory: module/pid of Territory
  fog: visability
  grid: combined information territory + player
  """
  use Agent

  alias Sim.Grid
  alias Meeple.Territory

  alias Meeple.Territory.One
  alias Meeple.Territory.Test, as: TestTerritory

  @full_visability 5
  @only_vegetation 1
  @terra_incognita 0

  def start_link(args \\ []) do
    Agent.start_link(
      fn -> %{territory: args[:territory] || Territory, grid: nil, fog: nil} end,
      name: args[:name] || __MODULE__
    )
  end

  def create(name, pid \\ __MODULE__) do
    Agent.get_and_update(pid, fn state ->
      fog = create_fog(name)
      grid = sync_grid(fog, state.territory)
      {:ok, %{state | fog: fog, grid: grid}}
    end)
  end

  def get(pid \\ __MODULE__) do
    Agent.get(pid, &get_grid(&1))
  end

  def field(x, y, pid \\ __MODULE__) do
    Agent.get(pid, &get_field(x, y, &1))
  end

  def update_grid(pid \\ __MODULE__) do
    Agent.update(pid, fn %{territory: territory, fog: fog} = state ->
      grid = sync_grid(fog, territory)
      %{state | grid: grid}
    end)
  end

  def update_field(x, y, pid \\ __MODULE__) do
    Agent.get_and_update(pid, fn %{territory: territory, fog: fog, grid: grid} = state ->
      visability = Grid.get(fog, x, y)
      {field, grid} = update_field_from_territory(x, y, grid, visability, territory)
      {field, %{state | grid: grid}}
    end)
  end

  def discover(x, y, pid \\ __MODULE__) do
    Agent.cast(pid, fn %{territory: territory, fog: fog, grid: grid} = state ->
      fog = Grid.put(fog, x, y, @full_visability)
      {_field, grid} = update_field_from_territory(x, y, grid, @full_visability, territory)
      %{state | fog: fog, grid: grid}
    end)
  end

  defp create_fog("test"), do: create_fog(TestTerritory, 3, 4)
  defp create_fog("one"), do: create_fog(One, 15, 7)

  defp create_fog(module, width, height) when is_atom(module) do
    Grid.create(width, height, &module.create_fog/2)
  end

  defp get_grid(%{grid: nil}), do: raise("grid has not yet been created")
  defp get_grid(%{grid: grid}), do: Grid.map(grid)

  defp get_field(_x, _y, %{grid: nil}), do: raise("grid has not yet been created")
  defp get_field(x, y, %{grid: grid}), do: Grid.get(grid, x, y)

  defp sync_grid(fog, territory) do
    Grid.create(Grid.width(fog), Grid.height(fog), fn x, y ->
      fetch_field_from_territory(x, y, Grid.get(fog, x, y), territory)
    end)
  end

  defp update_field_from_territory(x, y, grid, visability, territory) do
    field = fetch_field_from_territory(x, y, visability, territory)

    grid = Grid.put(grid, x, y, field)
    {field, grid}
  end

  defp fetch_field_from_territory(x, y, visability, territory) do
    get_field_from_territory(x, y, visability, territory)
    |> Map.merge(%{visability: visability})
  end

  defp get_field_from_territory(x, y, visability, territory) do
    case visability do
      @full_visability -> Territory.field(x, y, territory)
      @only_vegetation -> %{vegetation: Territory.field(x, y, territory) |> Map.get(:vegetation)}
      @terra_incognita -> %{}
    end
  end
end
