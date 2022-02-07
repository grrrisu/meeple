defmodule Meeple.ActionTest do
  use ExUnit.Case, async: true

  alias Meeple.{Action, Pawn}

  setup do
    Phoenix.PubSub.subscribe(Meeple.PubSub, "GameSession")

    pawn = %Pawn{id: 1, x: 1, y: 1}

    %{pawn: pawn}
  end

  test "calculate move action for distance 3", %{pawn: pawn} do
    move = Action.build_move(pawn, 1, 4)
    assert %{name: :move, x: 1, y: 4, points: 1} = move
  end

  test "calculate move action for distance 4", %{pawn: pawn} do
    move = Action.build_move(pawn, 2, 4)
    assert %{name: :move, x: 2, y: 4, points: 2} = move
  end

  test "build a discover action", %{pawn: pawn} do
    assert %Action{name: :discover, points: 4, x: 2, y: 3} = Action.build_discover(pawn, 2, 3)
  end
end
