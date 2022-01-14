defmodule Meeple.Territory do
  use Agent

  alias Sim.Grid
  alias Meeple.Territory.One
  alias Meeple.Territory.Test, as: TestTerritory

  def start_link(args) do
    Agent.start_link(fn -> nil end, name: args[:name] || __MODULE__)
  end

  def exists?(pid \\ __MODULE__) do
    Agent.get(pid, fn root -> !is_nil(root) end)
  end

  def get(pid \\ __MODULE__) do
    Agent.get(pid, &get_grid/1)
  end

  def field(x, y, pid \\ __MODULE__) do
    Agent.get(pid, fn %{fog_of_war: fog, ground: ground} ->
      get_field(ground, Grid.get(fog, x, y), x, y)
    end)
  end

  def dimensions(pid \\ __MODULE__) do
    Agent.get(pid, &get_dimensions/1)
  end

  def create(name, pid \\ __MODULE__) do
    Agent.get_and_update(pid, fn _ ->
      state = create_grid(name)
      {get_grid(state), state}
    end)
  end

  def load(name, pid \\ __MODULE__) do
    Agent.get_and_update(pid, fn state ->
      state =
        case state do
          nil -> create(name)
          %{} -> state
        end

      {get_grid(state), state}
    end)
  end

  def discover(x, y, pid \\ __MODULE__) do
    Agent.get_and_update(pid, fn state ->
      new_fog = Grid.put(state.fog_of_war, x, y, 5)
      field = get_field(state.ground, 5, x, y)
      {field, %{state | fog_of_war: new_fog}}
    end)
  end

  def get_dimensions(nil) do
    {0, 0}
  end

  def get_dimensions(%{fog_of_war: fog}) do
    {Grid.width(fog), Grid.height(fog)}
  end

  defp create_grid("test"), do: create_grid(TestTerritory, 3, 4)
  defp create_grid("one"), do: create_grid(One, 15, 7)

  defp create_grid(module, width, height) when is_atom(module) do
    %{
      fog_of_war: Grid.create(width, height, &module.create_fog/2),
      ground: module.create_ground(width, height)
    }
  end

  defp get_grid(nil), do: nil

  defp get_grid(%{fog_of_war: fog, ground: ground}) do
    Grid.create(Grid.width(fog), Grid.height(fog), fn x, y ->
      get_field(ground, Grid.get(fog, x, y), x, y)
    end)
  end

  defp get_field(ground, visability, x, y) do
    case visability do
      5 -> Grid.get(ground, x, y)
      1 -> %{vegetation: Grid.get(ground, x, y) |> Map.get(:vegetation)}
      0 -> %{}
    end
  end
end
