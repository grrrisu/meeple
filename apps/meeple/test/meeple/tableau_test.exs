defmodule Meeple.TebleauTest do
  use ExUnit.Case, async: true

  alias Meeple.Tableau

  setup do
    pid = start_supervised!({Tableau, name: :test_tableau})
    :ok = Tableau.create("test", pid)
    %{pid: pid}
  end

  test "get pawns from created tableau", %{pid: pid} do
    pawns = Tableau.pawns(pid)
    assert [%{id: 1}] = pawns
  end
end
