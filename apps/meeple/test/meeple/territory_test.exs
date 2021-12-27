defmodule Meeple.TerritoryTest do
  use ExUnit.Case, async: true

  alias Meeple.Territory
  alias Sim.Grid

  setup do
    pid = start_supervised!({Territory, name: :test_territory})
    %{territory: Territory.create("test", pid), pid: pid}
  end

  test "get headquarter", %{territory: territory} do
    field = Grid.get(territory, 1, 1)
    assert :headquarter = field[:building]
  end

  test "fog of war", %{territory: territory} do
    assert %{} = Grid.get(territory, 0, 0)
  end

  test "discover", %{territory: territory, pid: pid} do
    assert %{} = Grid.get(territory, 1, 2)
    field = Territory.discover(1, 2, pid)
    assert %{vegetation: :planes} = field
  end
end
