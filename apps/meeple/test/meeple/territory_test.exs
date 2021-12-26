defmodule Meeple.TerritoryTest do
  use ExUnit.Case, async: true

  alias Meeple.Territory
  alias Sim.Grid

  setup_all do
    pid = start_supervised!({Territory, name: :test_territory})
    %{territory: Territory.get(pid)}
  end

  test "get headquarter", %{territory: territory} do
    field = Grid.get(territory, 7, 1)
    assert :headquarter = field[:building]
  end

  test "fog of war", %{territory: territory} do
    assert %{} = Grid.get(territory, 0, 0)
  end
end
