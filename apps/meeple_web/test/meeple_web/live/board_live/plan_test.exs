defmodule MeepleWeb.BoardLive.PlanTest do
  use MeepleWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Meeple.{Board, Pawn}
  alias Meeple.Service.Admin

  setup do
    Admin.execute(:create, name: "test")
  end

  test "setup board", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")
    assert view |> has_element?("#plan")
  end

  test "add action to plan wall", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")

    Board.add_action(%Pawn{id: 1, x: 1, y: 2}, :discover, x: 1, y: 2)
    send(view.pid, {:plan_updated})

    {:ok, view, _html} = live(conn, "/board")

    assert view
           |> element("#plan")
           |> render() =~ "action_discover.svg"
  end

  test "hour timeline", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")
    assert view |> element("#plan-hour-timeline") |> render() =~ "sun_symbol.svg"
  end
end
