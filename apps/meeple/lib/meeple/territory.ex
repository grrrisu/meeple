defmodule Meeple.Territory do
  use Agent

  alias Sim.Grid
  alias Meeple.Territory.One

  def start_link(args) do
    Agent.start_link(&create/0, name: args[:name] || __MODULE__)
  end

  def get(pid \\ __MODULE__) do
    Agent.get(pid, &get_grid/1)
  end

  def discover(x, y, pid \\ __MODULE__) do
    Agent.get_and_update(pid, fn state ->
      new_fog = Grid.put(state.fog_of_war, x, y, 5)
      field = get_field(state.ground, 5, x, y)
      {field, %{state | fog_of_war: new_fog}}
    end)
  end

  defp create do
    %{
      fog_of_war: Grid.create(15, 7, &create_fog/2),
      ground: One.create(15, 7)
    }
  end

  defp create_fog(7, 1), do: 5
  defp create_fog(4, 5), do: 1
  defp create_fog(11, 5), do: 1
  defp create_fog(_x, _y), do: 0

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
