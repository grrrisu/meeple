defmodule MeepleWeb.BoardLive.PawnsTest do
  use MeepleWeb.ConnCase
  import Phoenix.LiveViewTest

  test "setup board", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board/test")
    assert view |> has_element?("#pawns")
  end
end
