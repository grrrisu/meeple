defmodule MeepleWeb.BoardLive.MapTest do
  use MeepleWeb.ConnCase
  import Phoenix.LiveViewTest

  test "setup board", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")
    assert view |> has_element?("#map")
  end
end
