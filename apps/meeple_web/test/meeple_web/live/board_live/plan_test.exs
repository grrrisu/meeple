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
end
