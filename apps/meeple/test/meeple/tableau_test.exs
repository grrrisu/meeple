defmodule Meeple.TebleauTest do
  use ExUnit.Case, async: true

  alias Meeple.{Pawn, Tableau}

  setup do
    pid = start_supervised!({Tableau, name: :test_tableau})
    :ok = Tableau.create("test", pid)
    %{pid: pid}
  end

  test "get pawns from created tableau", %{pid: pid} do
    pawns = Tableau.pawns(pid)
    assert [%Pawn{id: 1}] = pawns
  end

  test "find pawn with id", %{pid: pid} do
    pawn = Tableau.get_pawn(1, pid)
    assert %Pawn{id: 1} = pawn
  end

  test "return error if pawn could not be found", %{pid: pid} do
    pawn = Tableau.get_pawn(4, pid)
    assert {:error, _msg} = pawn
  end

  test "update pawn", %{pid: pid} do
    [pawn] = Tableau.pawns(pid)
    assert %Pawn{x: 1, y: 1} = pawn
    :ok = Tableau.update_pawn(%Pawn{pawn | y: 2}, pid)
    assert [%Pawn{x: 1, y: 2}] = Tableau.pawns(pid)
  end
end
