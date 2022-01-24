defmodule Meeple.Territory.One do
  alias Sim.Grid

  def all() do
    %{
      fields: fields(),
      group_names: group_names() |> Enum.map(fn {_n, key} -> key end),
      groups: %{headquarter: group(0), mountains_south: group(1)}
    }
  end

  def headquarter(), do: {7, 1}

  def pawns() do
    [%{id: 1, x: 7, y: 1, action_points: 12, planned: 0, executed: 0}]
  end

  def inventory() do
    [flintstone: 1, berry: 15]
  end

  def xp_pool() do
    %{red: 0, yellow: 0, green: 0, blue: 0, purple: 0}
  end

  def create_fog(7, 1), do: 5
  def create_fog(4, 5), do: 1
  def create_fog(11, 5), do: 1
  def create_fog(_x, _y), do: 0

  def create_ground(width, height) do
    [x, y, z] = Enum.shuffle([:home_hills, :home_mountains, :home_woods])
    [a, b, c, d] = Enum.shuffle([:woods, :planes, :hills, :lake])
    [m, n, o, p] = Enum.shuffle([:mountains, :mountains, :enemy_hills, :swamp])

    Grid.create(width, height, fields())
    |> populate(%{
      0 => group(:headquarter) |> Enum.shuffle(),
      1 => group(:back_mountains) |> Enum.shuffle(),
      2 => group(x) |> Enum.shuffle(),
      3 => group(y) |> Enum.shuffle(),
      4 => group(z) |> Enum.shuffle(),
      5 => group(a) |> Enum.shuffle(),
      6 => group(b) |> Enum.shuffle(),
      7 => group(c) |> Enum.shuffle(),
      8 => group(d) |> Enum.shuffle(),
      9 => group(m) |> Enum.shuffle(),
      10 => group(n) |> Enum.shuffle(),
      11 => group(o) |> Enum.shuffle(),
      12 => group(p) |> Enum.shuffle(),
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

  def group(:headquarter) do
    [%{vegetation: :mountains, building: :headquarter}]
  end

  def group(:back_mountains) do
    [
      %{vegetation: :high_mountains, flora: [:berry, 2]},
      %{vegetation: :high_mountains, flora: [:berry, 2], danger: [:snake, 3]},
      %{vegetation: :high_mountains, danger: [:rockfall, 3]},
      %{vegetation: :high_mountains, danger: [:rockfall, 2]},
      %{vegetation: :high_mountains, danger: [:rockfall, 2]},
      %{vegetation: :high_mountains},
      %{vegetation: :high_mountains},
      %{vegetation: :high_mountains},
      %{vegetation: :high_mountains}
    ]
  end

  def group(:home_woods) do
    [
      %{vegetation: :woods, predator: [:fox, 3]},
      %{vegetation: :woods, herbivore: [:rabbit, 5]},
      %{vegetation: :woods, flora: [:berry, 4], herbivore: [:rabbit, 4]},
      %{vegetation: :woods, flora: [:berry, 4], herbivore: [:partridge, 3]},
      %{vegetation: :woods, flora: [:berry, 4], herbivore: [:partridge, 3]},
      %{vegetation: :woods, flora: [:berry, 4], herbivore: [:boar, 8]},
      %{vegetation: :woods, flora: [:berry, 4]},
      %{vegetation: :woods, danger: [:snake, 1]}
    ]
  end

  def group(:home_mountains) do
    [
      %{vegetation: :mountains, predator: [:lynx, 3]},
      %{vegetation: :mountains, herbivore: [:rabbit, 5]},
      %{vegetation: :mountains, herbivore: [:goat, 4]},
      %{vegetation: :mountains, flora: [:berry, 4], herbivore: [:goat, 3]},
      %{vegetation: :mountains, flora: [:berry, 4]},
      %{vegetation: :mountains, flora: [:berry, 4], herbivore: [:partridge, 3]},
      %{vegetation: :mountains, danger: [:rockfall, 2]},
      %{vegetation: :mountains, danger: [:snake, 1]}
    ]
  end

  def group(:home_hills) do
    [
      %{vegetation: :hills, predator: [:fox, 3]},
      %{vegetation: :hills, herbivore: [:partridge, 5]},
      %{vegetation: :hills, flora: [:berry, 4], herbivore: [:partridge, 4]},
      %{vegetation: :hills, flora: [:berry, 4], herbivore: [:partridge, 3]},
      %{vegetation: :hills, flora: [:berry, 4], herbivore: [:rabbit, 3]},
      %{vegetation: :hills, flora: [:berry, 4]},
      %{vegetation: :hills},
      %{vegetation: :hills, danger: [:snake, 1]}
    ]
  end

  def group(:hills) do
    [
      %{vegetation: :hills, flora: [:berry, 2], predator: [:wolf, 3]},
      %{vegetation: :hills, flora: [:berry, 2], predator: [:bear, 3]},
      %{vegetation: :hills, flora: [:berry, 2], predator: [:fox, 3]},
      %{vegetation: :hills, flora: [:berry, 3], herbivore: [:rabbit, 5]},
      %{vegetation: :hills, flora: [:berry, 2], herbivore: [:rabbit, 4]},
      %{vegetation: :hills, flora: [:root, 4], herbivore: [:rabbit, 3]},
      %{vegetation: :hills, flora: [:root, 4], herbivore: [:partridge, 3]},
      %{vegetation: :hills, flora: [:root, 2], herbivore: [:partridge, 3]},
      %{vegetation: :hills, flora: [:mushroom, 4], herbivore: [:partridge, 3]},
      %{vegetation: :hills, flora: [:mushroom, 3], herbivore: [:partridge, 3]},
      %{vegetation: :hills, flora: [:berry, 2], herbivore: [:deer, 3]},
      %{vegetation: :hills, flora: [:berry, 2], herbivore: [:deer, 3]},
      %{vegetation: :hills, flora: [:berry, 2], herbivore: [:aurochs, 3]}
    ]
  end

  def group(:planes) do
    [
      %{vegetation: :planes, flora: [:berry, 2], predator: [:cave_lion, 3]},
      %{vegetation: :planes, flora: [:berry, 2], predator: [:wolf, 3]},
      %{vegetation: :planes, flora: [:berry, 2], predator: [:fox, 3]},
      %{vegetation: :planes, flora: [:berry, 3], herbivore: [:rabbit, 5]},
      %{vegetation: :planes, flora: [:berry, 2], herbivore: [:rabbit, 4]},
      %{vegetation: :planes, flora: [:root, 4], herbivore: [:rabbit, 3]},
      %{vegetation: :planes, flora: [:root, 4], herbivore: [:partridge, 3]},
      %{vegetation: :planes, flora: [:root, 2], herbivore: [:partridge, 3]},
      %{vegetation: :planes, flora: [:mushroom, 4], herbivore: [:partridge, 3]},
      %{vegetation: :planes, flora: [:mushroom, 3], herbivore: [:partridge, 3]},
      %{vegetation: :planes, flora: [:berry, 2], herbivore: [:aurochs, 3]},
      %{vegetation: :planes, flora: [:berry, 2], herbivore: [:aurochs, 3]},
      %{vegetation: :planes, flora: [:berry, 2], herbivore: [:aurochs, 3]}
    ]
  end

  def group(:woods) do
    [
      %{vegetation: :woods, flora: [:berry, 2], predator: [:bear, 3]},
      %{vegetation: :woods, flora: [:berry, 2], predator: [:wolf, 3]},
      %{vegetation: :woods, flora: [:berry, 2], predator: [:fox, 3]},
      %{vegetation: :woods, flora: [:berry, 3], herbivore: [:rabbit, 5]},
      %{vegetation: :woods, flora: [:berry, 2], herbivore: [:rabbit, 4]},
      %{vegetation: :woods, flora: [:root, 4], herbivore: [:rabbit, 3]},
      %{vegetation: :woods, flora: [:root, 4], herbivore: [:partridge, 3]},
      %{vegetation: :woods, flora: [:root, 2], herbivore: [:partridge, 3]},
      %{vegetation: :woods, flora: [:mushroom, 4], herbivore: [:partridge, 3]},
      %{vegetation: :woods, flora: [:mushroom, 3], herbivore: [:partridge, 3]},
      %{vegetation: :woods, flora: [:berry, 2], herbivore: [:deer, 3]},
      %{vegetation: :woods, flora: [:berry, 2], herbivore: [:deer, 3]},
      %{vegetation: :woods, flora: [:berry, 2], herbivore: [:deer, 3]}
    ]
  end

  def group(:lake) do
    [
      %{vegetation: :woods, flora: [:berry, 2], predator: [:bear, 3]},
      %{vegetation: :woods, flora: [:berry, 2], predator: [:wolf, 3]},
      %{vegetation: :woods, flora: [:berry, 2], predator: [:fox, 3]},
      %{vegetation: :woods, flora: [:berry, 3], herbivore: [:rabbit, 5]},
      %{vegetation: :woods, flora: [:berry, 2], herbivore: [:rabbit, 4]},
      %{vegetation: :woods, flora: [:root, 4], herbivore: [:rabbit, 3]},
      %{vegetation: :planes, flora: [:root, 4], herbivore: [:partridge, 3]},
      %{vegetation: :planes, flora: [:root, 2], herbivore: [:partridge, 3]},
      %{vegetation: :planes, flora: [:mushroom, 4], herbivore: [:partridge, 3]},
      %{vegetation: :planes, flora: [:mushroom, 3], herbivore: [:partridge, 3]},
      %{vegetation: :hills, flora: [:berry, 2], herbivore: [:deer, 3]},
      %{vegetation: :hills, flora: [:berry, 2], herbivore: [:deer, 3]},
      %{vegetation: :lake, herbivore: [:fish, 5]}
    ]
  end

  def group(:mountains) do
    [
      %{vegetation: :mountains, flora: [:berry, 2], predator: [:bear, 3]},
      %{vegetation: :mountains, flora: [:berry, 2], predator: [:lynx, 3]},
      %{vegetation: :mountains, flora: [:berry, 2], predator: [:cave_lion, 3]},
      %{vegetation: :mountains, flora: [:berry, 3], herbivore: [:rabbit, 5]},
      %{vegetation: :mountains, flora: [:berry, 2], herbivore: [:rabbit, 4]},
      %{vegetation: :mountains, flora: [:root, 4], herbivore: [:rabbit, 3]},
      %{vegetation: :mountains, flora: [:root, 4], herbivore: [:goat, 3]},
      %{vegetation: :mountains, flora: [:root, 2], herbivore: [:goat, 3]},
      %{vegetation: :mountains, flora: [:mushroom, 4], herbivore: [:partridge, 3]},
      %{vegetation: :mountains, flora: [:mushroom, 3], herbivore: [:partridge, 3]},
      %{vegetation: :mountains, flora: [:berry, 2], herbivore: [:goat, 3]},
      %{vegetation: :mountains, flora: [:berry, 2], herbivore: [:goat, 3]},
      %{vegetation: :mountains, flora: [:herbs, 2], herbivore: [:goat, 3]}
    ]
  end

  def group(:swamp) do
    [
      %{vegetation: :swamps, flora: [:berry, 2], predator: [:bear, 3]},
      %{vegetation: :swamps, flora: [:berry, 2], predator: [:wolf, 3]},
      %{vegetation: :swamps, flora: [:berry, 2], predator: [:fox, 3]},
      %{vegetation: :swamps, flora: [:berry, 3], herbivore: [:rabbit, 5]},
      %{vegetation: :swamps, flora: [:berry, 2], herbivore: [:rabbit, 4]},
      %{vegetation: :swamps, flora: [:root, 4], herbivore: [:rabbit, 3]},
      %{vegetation: :swamps, flora: [:root, 4], herbivore: [:boar, 3]},
      %{vegetation: :swamps, flora: [:root, 2], herbivore: [:boar, 3]},
      %{vegetation: :swamps, flora: [:mushroom, 4], herbivore: [:partridge, 3]}
    ]
  end

  def group(:enemy_hills) do
    [
      %{vegetation: :hills, flora: [:berry, 2], predator: [:bear, 3]},
      %{vegetation: :hills, flora: [:berry, 2], predator: [:wolf, 3]},
      %{vegetation: :hills, flora: [:berry, 2], predator: [:fox, 3]},
      %{vegetation: :hills, flora: [:berry, 3], herbivore: [:rabbit, 5]},
      %{vegetation: :hills, flora: [:berry, 2], herbivore: [:rabbit, 4]},
      %{vegetation: :hills, flora: [:root, 4], herbivore: [:rabbit, 3]},
      %{vegetation: :hills, flora: [:root, 4], herbivore: [:boar, 3]},
      %{vegetation: :hills, flora: [:root, 2], herbivore: [:boar, 3]},
      %{vegetation: :hills, flora: [:mushroom, 4], herbivore: [:partridge, 3]}
    ]
  end
end
