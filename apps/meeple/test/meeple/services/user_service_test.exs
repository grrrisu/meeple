defmodule Meeple.Service.UserTest do
  use ExUnit.Case, async: true

  alias Meeple.{Action, Plan, Pawn}
  alias Meeple.Service.User

  setup do
    pid = start_supervised!({Plan, name: :plan_test})
    pawn = %Pawn{id: 1, x: 1, y: 1}
    %{pid: pid, pawn: pawn}
  end

  test "add discover action", %{pawn: pawn} do
    actions = User.prepare_actions([], pawn: pawn, action: :discover, x: 1, y: 2)
    assert 2 == Enum.count(actions)
    assert [%{name: :move}, %{name: :discover, points: 4}] = actions
    # assert 5 == plan.total_points
  end

  test "add move action if pawn is not on the field for his first action", %{pawn: pawn} do
    actions = User.prepare_actions([], pawn: pawn, action: :discover, x: 1, y: 2)
    assert 2 == Enum.count(actions)
    assert [%{name: :move, x: 1, y: 2, points: 1}, %{name: :discover}] = actions
  end

  test "add move action if pawn is not on the field since his last action", %{pawn: pawn} do
    planned = [%Action{pawn: pawn, name: :move, points: 1, x: 1, y: -2}]
    actions = User.prepare_actions(planned, pawn: pawn, action: :discover, x: 1, y: 2)
    assert 2 == Enum.count(actions)

    assert [
             %{name: :move, x: 1, y: 2, points: 2},
             %{name: :discover}
           ] = actions
  end

  test "add no move action if pawn is already on the field", %{pawn: pawn} do
    planned = [%Action{pawn: pawn, name: :move, points: 1, x: 1, y: 2}]
    actions = User.prepare_actions(planned, pawn: pawn, action: :discover, x: 1, y: 2)
    assert 1 == Enum.count(actions)
    assert [%{name: :discover}] = actions
  end

  test "add no move action if added action is a move action", %{pawn: pawn} do
    actions = User.prepare_actions([], pawn: pawn, action: :move, x: 1, y: 2)
    assert 1 == Enum.count(actions)
    assert [%{name: :move}] = actions
  end
end
