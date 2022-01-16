defmodule Meeple.TerritoryTest do
  use ExUnit.Case, async: true

  alias Meeple.Territory

  setup do
    pid = start_supervised!({Territory, name: :test_territory})
    :ok = Territory.create("test", pid)
    %{pid: pid}
  end

  test "get headquarter", %{pid: pid} do
    field = Territory.field(1, 1, pid)
    assert :headquarter = field[:building]
  end

  test "fog of war", %{pid: pid} do
    assert %{} = Territory.field(0, 0, pid)
  end
end
