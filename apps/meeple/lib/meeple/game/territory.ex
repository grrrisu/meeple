defmodule Meeple.Territory do
  use Agent

  alias Ximula.Grid
  alias Meeple.Territory.One
  alias Meeple.Territory.Test, as: TestTerritory

  def start_link(args) do
    Agent.start_link(fn -> nil end, name: args[:name] || __MODULE__)
  end

  def exists?(pid \\ __MODULE__) do
    Agent.get(pid, fn root -> !is_nil(root) end)
  end

  def field(x, y, pid \\ __MODULE__) do
    Agent.get(pid, &Grid.get(&1, x, y))
  end

  def get(pid \\ __MODULE__) do
    Agent.get(pid, &Grid.sorted_list(&1, :cartesian))
  end

  def dimensions(pid \\ __MODULE__) do
    Agent.get(pid, &get_dimensions/1)
  end

  def create(name, pid \\ __MODULE__) do
    Agent.get_and_update(pid, fn _ ->
      state = create_grid(name)
      {:ok, state}
    end)
  end

  def set_pawn(pawn, pid \\ __MODULE__) do
    Agent.cast(pid, fn grid ->
      pawns = [pawn.id | Grid.get(grid, pawn.x, pawn.y) |> Map.get(:pawns, [])] |> Enum.uniq()
      Grid.merge_field(grid, pawn.x, pawn.y, %{pawns: pawns})
    end)
  end

  def move_pawn(pawn, x, y, pid \\ __MODULE__) do
    Agent.get_and_update(pid, fn grid ->
      from_field = Grid.get(grid, pawn.x, pawn.y)
      pawns = Map.get(from_field, :pawns, []) |> List.delete(pawn.id)
      grid = Grid.merge_field(grid, pawn.x, pawn.y, %{pawns: pawns})
      to_field = Grid.get(grid, x, y)
      pawns = [pawn.id | Map.get(to_field, :pawns, [])]
      grid = Grid.merge_field(grid, x, y, %{pawns: pawns})
      {%{pawn | x: x, y: y}, grid}
    end)
  end

  def get_dimensions(nil) do
    {0, 0}
  end

  def get_dimensions(grid) do
    {Grid.width(grid), Grid.height(grid)}
  end

  defp create_grid("test"), do: create_grid(TestTerritory, 3, 4)
  defp create_grid("one"), do: create_grid(One, 15, 7)

  defp create_grid(module, width, height) when is_atom(module) do
    module.create_ground(width, height)
  end
end
