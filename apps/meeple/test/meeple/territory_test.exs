defmodule Meeple.TerritoryTest do
  use ExUnit.Case, async: true

  alias Meeple.Territory

  setup do
    pid = start_supervised!({Territory, name: :test_territory})
    :ok = Territory.create("test", pid)
    %{pid: pid}
  end

  test "get created view", %{pid: pid} do
    fields = Territory.get(pid)
    assert 12 = Enum.count(fields)
    assert Enum.member?(fields, {1, 1, %{building: :headquarter, vegetation: :mountains}})
  end

  test "get field", %{pid: pid} do
    field = Territory.field(1, 2, pid)
    assert :planes = field[:vegetation]
  end

  test "set pawn", %{pid: pid} do
    :ok = Territory.set_pawn(%{id: 1, x: 2, y: 2}, pid)
    field = Territory.field(2, 2, pid)
    assert [1] = field.pawns
    :ok = Territory.set_pawn(%{id: 5, x: 2, y: 2}, pid)
    field = Territory.field(2, 2, pid)
    assert [5, 1] = field.pawns
  end

  test "move pawn", %{pid: pid} do
    pawn = %{id: 1, x: 2, y: 2}
    :ok = Territory.set_pawn(pawn, pid)
    pawn = Territory.move_pawn(pawn, 2, 1, pid)
    from = Territory.field(2, 2, pid)
    to = Territory.field(2, 1, pid)
    assert %{x: 2, y: 1} = pawn
    assert Enum.empty?(from.pawns)
    assert [1] = to.pawns
  end
end
