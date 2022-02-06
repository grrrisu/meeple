defmodule Meeple.ActionTest do
  use ExUnit.Case, async: true

  alias Meeple.{Action, Pawn}

  setup do
    Phoenix.PubSub.subscribe(Meeple.PubSub, "GameSession")

    discover_action = %Action{
      name: :discover,
      pawn: %Pawn{id: 1, x: 1, y: 1},
      x: 1,
      y: 2,
      points: 4
    }

    %{action: discover_action}
  end

  test "calculate move action for distance 3", %{action: action} do
    action = %Action{action | y: 4}
    move = Action.build_move(action, {1, 1})
    assert %{name: :move, x: 1, y: 4, points: 1} = move
  end

  test "calculate move action for distance 4", %{action: action} do
    action = %Action{action | x: 2, y: 4}
    move = Action.build_move(action, {1, 1})
    assert %{name: :move, x: 2, y: 4, points: 2} = move
  end
end
