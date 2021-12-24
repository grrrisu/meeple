defmodule Meeple.Territory.One do
  alias Sim.Grid

  def all() do
    %{
      fields: fields(),
      group_names: group_names() |> Enum.map(fn {_n, key} -> key end),
      groups: %{headquarter: group(0), mountains_south: group(1)}
    }
  end

  def create() do
    [a, b, c, d] = Enum.shuffle([5, 5, 6, 6])

    Grid.create(15, 7, fields())
    |> populate(%{
      0 => group(0) |> Enum.shuffle(),
      1 => group(1) |> Enum.shuffle(),
      2 => group(2) |> Enum.shuffle(),
      3 => group(2) |> Enum.shuffle(),
      4 => group(2) |> Enum.shuffle(),
      5 => group(a) |> Enum.shuffle(),
      6 => group(b) |> Enum.shuffle(),
      7 => group(c) |> Enum.shuffle(),
      8 => group(d) |> Enum.shuffle(),
      9 => group(9) |> Enum.shuffle(),
      10 => group(9) |> Enum.shuffle(),
      11 => group(9) |> Enum.shuffle(),
      12 => group(9) |> Enum.shuffle(),
      13 => group(a) |> Enum.shuffle()
    })
  end

  def reduce_grid(width, height, acc, func) do
    grid = Grid.create(width, height)

    {_, new_grid} =
      Enum.reduce(0..14, {acc, grid}, fn x, {acc, grid} ->
        Enum.reduce(0..6, {acc, grid}, fn y, {acc, grid} ->
          {field, new_acc} = func.(x, y, acc)
          new_grid = Grid.put(grid, x, y, field)
          {new_acc, new_grid}
        end)
      end)

    new_grid
  end

  def populate(template, groups) do
    reduce_grid(15, 7, groups, fn x, y, groups ->
      key = Grid.get(template, x, y)

      case Map.get(groups, key) do
        nil -> {key, groups}
        [field | rest] -> {field, Map.put(groups, key, rest)}
      end
    end)
  end

  # 15 * 7 fields
  def fields() do
    [
      [11, 11, 11, 8, 8, 8, 8, 13, 7, 7, 7, 7, 12, 12, 12],
      [11, 11, 5, 8, 8, 8, 8, 4, 7, 7, 7, 7, 6, 12, 12],
      [11, 5, 5, 5, 8, 8, 4, 4, 4, 7, 7, 6, 6, 6, 12],
      [5, 5, 5, 5, 5, 3, 4, 4, 4, 2, 6, 6, 6, 6, 6],
      [9, 5, 5, 5, 3, 3, 3, 4, 2, 2, 2, 6, 6, 6, 10],
      [9, 9, 5, 3, 3, 3, 3, 0, 2, 2, 2, 2, 6, 10, 10],
      [9, 9, 9, 1, 1, 1, 1, 1, 1, 1, 1, 1, 10, 10, 10]
    ]
  end

  def group_names() do
    [
      {0, :headquarter},
      # 9
      {1, :mountains_south},
      # 8
      {2, :home_east},
      # 8
      {3, :home_west},
      # 8
      {4, :home_north},
      # 13
      {5, :west},
      # 13
      {6, :east},
      # 12
      {7, :north_east},
      # 12
      {8, :north_west},
      # 6 / 13
      {9, :mountains_south_west},
      # 6 / 13
      {10, :mountains_south_east},
      # 6 / 13
      {11, :mountains_west},
      # 6 / 13
      {12, :mountains_east},
      # 1, 13
      {13, :north}
    ]
  end

  def group(0) do
    [%{building: :headquarter}]
  end

  def group(1) do
    [
      %{food: [:berry, 2, 2]},
      %{food: [:berry, 2, 2]},
      %{danger: [:rockfall, 3]},
      %{danger: [:rockfall, 2]},
      %{danger: [:rockfall, 2]},
      %{},
      %{},
      %{},
      %{}
    ]
  end

  def group(2) do
    [
      %{food: [:berry, 4, 4]},
      %{food: [:berry, 5, 5]},
      %{predator: [:fox, 1]},
      %{predator: [:fox, 1]},
      %{predator: [:fox, 1]},
      %{},
      %{},
      %{}
    ]
  end

  def group(5) do
    [
      %{food: [:berry, 4, 4]},
      %{food: [:berry, 5, 5]},
      %{predator: [:bear, 5]},
      %{predator: [:wolf, 4]},
      %{predator: [:fox, 1]},
      %{herbivore: [:deer, 4]},
      %{herbivore: [:deer, 4]},
      %{herbivore: [:deer, 4]},
      %{herbivore: [:deer, 4]},
      %{},
      %{},
      %{},
      %{},
      %{}
    ]
  end

  def group(6) do
    [
      %{food: [:berry, 4, 4]},
      %{food: [:berry, 5, 5]},
      %{predator: [:wolf, 5]},
      %{predator: [:wolf, 4]},
      %{predator: [:cave_lion, 5]},
      %{herbivore: [:bison, 4]},
      %{herbivore: [:bison, 4]},
      %{herbivore: [:bison, 4]},
      %{herbivore: [:rabbit, 2]},
      %{herbivore: [:rabbit, 2]},
      %{},
      %{},
      %{},
      %{}
    ]
  end

  def group(9) do
    [
      %{food: [:berry, 4, 4]},
      %{food: [:berry, 5, 5]},
      %{herbivore: [:goat, 3]},
      %{predator: [:wolf, 4]},
      %{predator: [:cave_lion, 5]},
      %{predator: [:lynx, 3]}
    ]
  end
end
