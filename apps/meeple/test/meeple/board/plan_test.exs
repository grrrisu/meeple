defmodule Meeple.PlanTest do
  use ExUnit.Case, async: true

  alias Meeple.{Pawn, Plan}
  alias Meeple.PubSub

  setup do
    pid = start_supervised!({Plan, name: :plan_test})
    Phoenix.PubSub.subscribe(PubSub, "GameSession")
    pawn = %Pawn{id: 1, x: 1, y: 1}
    %{pid: pid, pawn: pawn}
  end

  test "get initial state", %{pid: pid} do
    plan = Plan.get(pid)
    assert %{actions: [], total_points: 0} = plan
  end

  test "add discover action", %{pid: pid, pawn: pawn} do
    :ok = Plan.add_action(pawn, :discover, [x: 1, y: 2], pid)
    plan = Plan.get(pid)
    assert 2 == Enum.count(plan.actions)
    assert [%{name: :move}, %{name: :discover}] = plan.actions
    assert 5 == plan.total_points
  end

  test "send event when an action has been added", %{pid: pid, pawn: pawn} do
    :ok = Plan.add_action(pawn, :discover, [x: 1, y: 2], pid)
    assert_receive({:plan_updated})
  end

  test "add move action if pawn is not on the field for his first action", %{pid: pid, pawn: pawn} do
    :ok = Plan.add_action(pawn, :discover, [x: 1, y: 2], pid)
    plan = Plan.get(pid)
    assert 2 == Enum.count(plan.actions)
    assert [%{name: :move, x: 1, y: 2, points: 1}, %{name: :discover}] = plan.actions
  end

  test "add move action if pawn is not on the field since his last action", %{
    pid: pid,
    pawn: pawn
  } do
    :ok = Plan.add_action(pawn, :move, [x: 1, y: -2], pid)
    :ok = Plan.add_action(pawn, :discover, [x: 1, y: 2], pid)
    plan = Plan.get(pid)
    assert 3 == Enum.count(plan.actions)

    assert [
             %{name: :move, x: 1, y: -2, points: 1},
             %{name: :move, x: 1, y: 2, points: 2},
             %{name: :discover}
           ] = plan.actions
  end

  test "add no move action if pawn is already on the field", %{pid: pid, pawn: pawn} do
    pawn = %Pawn{pawn | y: 2}
    :ok = Plan.add_action(pawn, :discover, [x: 1, y: 2], pid)
    plan = Plan.get(pid)
    assert 1 == Enum.count(plan.actions)
    assert [%{name: :discover}] = plan.actions
  end

  test "add no move action if added action is a move action", %{pid: pid, pawn: pawn} do
    :ok = Plan.add_action(pawn, :move, [x: 1, y: 2], pid)
    plan = Plan.get(pid)
    assert 1 == Enum.count(plan.actions)
    assert [%{name: :move}] = plan.actions
  end

  test "do nothing if action queue is empty", %{pid: pid} do
    :ok = Plan.tick(pid)
    plan = Plan.get(pid)
    assert %{actions: [], total_points: 0} = plan
  end

  test "increase done when action is not yet done", %{pid: pid, pawn: pawn} do
    pawn = %Pawn{pawn | y: 2}
    :ok = Plan.add_action(pawn, :discover, [x: 1, y: 2], pid)
    assert_receive({:plan_updated})
    :ok = Plan.tick(pid)
    assert_receive({:plan_updated})
    plan = Plan.get(pid)
    assert %{done: 1, points: 4} = plan.actions |> List.first()
  end

  test "keep action in queue when it's done", %{pid: pid, pawn: pawn} do
    :ok = Plan.add_action(pawn, :test, [x: 1, y: 2], pid)
    assert_receive({:plan_updated})
    :ok = Plan.tick(pid)
    assert_receive({:plan_updated})
    plan = Plan.get(pid)
    assert %{done: 1} = plan.actions |> List.first()
  end
end
