defmodule Meeple.Territory.OneTest do
  use ExUnit.Case, async: true

  alias Meeple.Territory.One
  alias Sim.Grid

  test "create ground" do
    territory = One.create_ground(15, 7)
    assert 7 = Grid.height(territory)
    assert 15 = Grid.width(territory)
    assert %{building: :headquarter} = Grid.get(territory, 7, 1)
  end

  test "create fog" do
    territory = Grid.create(15, 7, &One.create_fog/2)
    assert 7 = Grid.height(territory)
    assert 15 = Grid.width(territory)
    assert 5 = Grid.get(territory, 7, 1)
  end
end
