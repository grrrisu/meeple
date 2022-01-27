defmodule Meeple.FogOfWarTest do
  use ExUnit.Case, async: true

  alias Meeple.{FogOfWar, Territory}

  setup do
    territory_pid = start_supervised!({Territory, name: :fog_of_war_test_territory})

    fog_of_war_pid =
      start_supervised!({FogOfWar, territory: territory_pid, name: :fog_of_war_test_fog_of_war})

    :ok = Territory.create("test", territory_pid)
    :ok = FogOfWar.create("test", fog_of_war_pid)
    %{fog_of_war_pid: fog_of_war_pid, territory_pid: territory_pid}
  end

  test "get created view", %{fog_of_war_pid: pid} do
    fields = FogOfWar.get(pid)
    assert 12 = Enum.count(fields)
    assert Enum.member?(fields, {1, 1, %{building: :headquarter, vegetation: :mountains}})
  end

  test "get field headquarter", %{fog_of_war_pid: pid} do
    field = FogOfWar.field(1, 1, pid)
    assert ^field = %{building: :headquarter, vegetation: :mountains}
  end

  test "get undiscoverd field", %{fog_of_war_pid: pid} do
    field = FogOfWar.field(0, 3, pid)
    assert Enum.empty?(field)
  end

  test "update field", %{fog_of_war_pid: pid, territory_pid: territory_pid} do
    assert FogOfWar.field(1, 1, pid) |> Map.get(:pawns) |> is_nil()
    Territory.move_pawn(%{id: 1, x: 1, y: 1}, 1, 1, territory_pid)
    assert FogOfWar.field(1, 1, pid) |> Map.get(:pawns) |> is_nil()

    field = FogOfWar.update_field(1, 1, pid)
    assert %{pawns: [1]} = field
    assert %{pawns: [1]} = FogOfWar.field(1, 1, pid)
  end

  test "discover", %{fog_of_war_pid: pid} do
    assert %{} = FogOfWar.field(1, 2, pid)
    :ok = FogOfWar.discover(1, 2, pid)
    assert %{vegetation: :planes, visability: 5} = FogOfWar.field(1, 2, pid)
  end
end
