defmodule Meeple.PlanTest do
  use ExUnit.Case, async: true

  alias Meeple.{Action, Pawn, Plan}
  alias Meeple.PubSub

  setup do
    pid = start_supervised!({Plan, name: :plan_test})
    Phoenix.PubSub.subscribe(PubSub, "GameSession")

    discover_action = %Action{
      name: :discover,
      pawn: %Pawn{id: 1, x: 1, y: 1},
      x: 1,
      y: 2,
      points: 4
    }

    %{pid: pid, action: discover_action}
  end

  test "get initial state", %{pid: pid} do
    plan = Plan.get(pid)
    assert %{actions: [], total_points: 0} = plan
  end

  test "add discover action", %{pid: pid, action: action} do
    :ok = Plan.add_action(action, pid)
    plan = Plan.get(pid)
    assert 2 == Enum.count(plan.actions)
    assert [%{name: :move}, %{name: :discover}] = plan.actions
    assert 5 == plan.total_points
  end

  test "send event when a action has been added", %{pid: pid, action: action} do
    :ok = Plan.add_action(action, pid)
    assert_receive({:plan_updated})
  end

  test "add move action if pawn is not on the field", %{pid: pid, action: action} do
    :ok = Plan.add_action(action, pid)
    plan = Plan.get(pid)
    assert 2 == Enum.count(plan.actions)
    assert [%{name: :move, x: 1, y: 2, points: 1}, %{name: :discover}] = plan.actions
  end

  test "add no move action if pawn is already on the field", %{pid: pid, action: action} do
    action = %Action{action | y: 1}
    :ok = Plan.add_action(action, pid)
    plan = Plan.get(pid)
    assert 1 == Enum.count(plan.actions)
    assert [%{name: :discover}] = plan.actions
  end

  test "add no move action if added action is a move action", %{pid: pid, action: action} do
    action = %Action{action | name: :move}
    :ok = Plan.add_action(action, pid)
    plan = Plan.get(pid)
    assert 1 == Enum.count(plan.actions)
    assert [%{name: :move}] = plan.actions
  end

  test "calculate move action for distance 3", %{action: action} do
    action = %Action{action | y: 4}
    move = Plan.move_action(action)
    assert %{name: :move, x: 1, y: 4, points: 1} = move
  end

  test "calculate move action for distance 4", %{action: action} do
    action = %Action{action | x: 2, y: 4}
    move = Plan.move_action(action)
    assert %{name: :move, x: 2, y: 4, points: 2} = move
  end

  test "do nothing if action queue is empty", %{pid: pid} do
    :ok = Plan.tick(pid)
    plan = Plan.get(pid)
    assert %{actions: [], total_points: 0} = plan
  end

  test "add inc done when action is not yet done", %{pid: pid, action: action} do
    action = %Action{action | y: 1}
    :ok = Plan.add_action(action, pid)
    assert_receive({:plan_updated})
    :ok = Plan.tick(pid)
    assert_receive({:plan_updated})
    plan = Plan.get(pid)
    assert %{done: 1, points: 4} = plan.actions |> List.first()
  end

  test "remove action from queue when it's done", %{pid: pid, action: action} do
    action = %Action{action | name: :move, points: 3, done: 2}
    :ok = Plan.add_action(action, pid)
    assert_receive({:plan_updated})
    :ok = Plan.tick(pid)
    assert_receive({:plan_updated})
    plan = Plan.get(pid)
    assert Enum.empty?(plan.actions)
  end
end
