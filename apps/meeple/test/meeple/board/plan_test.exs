defmodule Meeple.PlanTest do
  use ExUnit.Case, async: true

  alias Meeple.{Action, Pawn, Plan}

  setup do
    pid = start_supervised!({Plan, name: :plan_test})
    pawn = %Pawn{id: 1, x: 1, y: 1}
    %{pid: pid, pawn: pawn}
  end

  test "get initial state", %{pid: pid} do
    plan = Plan.get(pid)
    assert %{actions: [], total_points: 0} = plan
  end

  test "do nothing if action queue is empty", %{pid: pid} do
    assert :empty = Plan.inc_action(pid)
    plan = Plan.get(pid)
    assert %{actions: [], total_points: 0} = plan
  end

  test "increase done when action is not yet done", %{pid: pid, pawn: pawn} do
    pawn = %Pawn{pawn | y: 2}
    :ok = Plan.add_action(%Action{pawn: pawn, name: :discover, x: 1, y: 2, points: 4}, pid)
    :increased = Plan.inc_action(pid)
    plan = Plan.get(pid)
    assert %{done: 1, points: 4} = plan.actions |> List.first()
  end

  test "keep action in queue when it's done", %{pid: pid, pawn: pawn} do
    :ok = Plan.add_action(%Action{pawn: pawn, name: :move, x: 1, y: 2, points: 1}, pid)
    {:executable, %Action{}} = Plan.inc_action(pid)
    plan = Plan.get(pid)
    assert %{done: 1} = plan.actions |> List.first()
  end
end
