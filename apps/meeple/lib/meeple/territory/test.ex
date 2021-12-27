defmodule Meeple.Territory.Test do
  alias Sim.Grid

  def create_fog(1, 1), do: 5
  def create_fog(2, 3), do: 1
  def create_fog(_x, _y), do: 0

  def create_ground(width, height) do
    Grid.create(width, height, ground())
  end

  defp ground() do
    [
      [
        %{vegetation: :planes, flora: [:mushroom, 2], predator: [:wolf, 3]},
        %{vegetation: :planes},
        %{vegetation: :planes, flora: [:berry, 2], herbivore: [:aurochs, 3]}
      ],
      [
        %{vegetation: :planes, flora: [:mushroom, 2], predator: [:wolf, 3]},
        %{vegetation: :planes},
        %{vegetation: :planes, flora: [:berry, 2], herbivore: [:aurochs, 3]}
      ],
      [
        %{vegetation: :woods, flora: [:berry, 3], predator: [:fox, 3]},
        %{vegetation: :mountains, building: :headquarter},
        %{vegetation: :woods, flora: [:nut, 3], herbivore: [:rabbit, 3]}
      ],
      [
        %{vegetation: :high_mountains},
        %{vegetation: :high_mountains},
        %{vegetation: :high_mountains}
      ]
    ]
  end
end
