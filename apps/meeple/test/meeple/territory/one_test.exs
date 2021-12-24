defmodule Meeple.Territory.OneTest do
  use ExUnit.Case, async: true

  alias Meeple.Territory.One
  alias Sim.Grid

  test "create a territory" do
    territory = One.create()
    assert 7 = Grid.height(territory)
    assert 15 = Grid.width(territory)
    assert %{building: :headquarter} = Grid.get(territory, 7, 1)
  end
end
