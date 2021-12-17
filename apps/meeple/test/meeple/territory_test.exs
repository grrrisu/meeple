defmodule Meeple.TerritoryTest do
  use ExUnit.Case, async: true

  alias Meeple.Territory
  alias Sim.Grid

  test "create a territory" do
    territory = Territory.create()
    assert 7 = Grid.height(territory)
    assert 15 = Grid.width(territory)
    assert :headquarter = Grid.get(territory, 7, 1)
  end
end
