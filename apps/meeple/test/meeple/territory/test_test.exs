defmodule Meeple.Territory.TestTest do
  use ExUnit.Case, async: true

  alias Meeple.Territory.Test, as: TestTerritory
  alias Ximula.Grid

  test "create ground" do
    territory = TestTerritory.create_ground(3, 4)
    assert 4 = Grid.height(territory)
    assert 3 = Grid.width(territory)
    assert %{building: :headquarter} = Grid.get(territory, 1, 1)
  end

  test "create fog" do
    territory = Grid.create(3, 4, &TestTerritory.create_fog/2)
    assert 4 = Grid.height(territory)
    assert 3 = Grid.width(territory)
    assert 5 = Grid.get(territory, 1, 1)
  end
end
