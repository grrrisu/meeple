defmodule MeepleWeb.BoardLive.PlanTest do
  use MeepleWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Meeple.Board

  setup do
    Board.create("test")
  end

  test "setup board", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")
    assert view |> has_element?("#plan")
  end

  test "add action to plan wall", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")

    Board.add_action(%{
      name: :discover,
      pawn: %{id: 1, x: 1, y: 2},
      x: 1,
      y: 2,
      points: 4,
      done: 0
    })

    send(view.pid, {:plan_updated})

    {:ok, view, _html} = live(conn, "/board")

    assert view
           |> element("#plan")
           |> render() =~ "action_discover.svg"
  end
end
