defmodule MeepleWeb.BoardLive.MapTest do
  use MeepleWeb.ConnCase
  import Phoenix.LiveViewTest

  test "setup board", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")
    assert view |> has_element?("#map")
  end

  test "field", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")
    assert view |> has_element?("#field-7-1", "headquarter")
  end

  test "discover", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")

    view
    |> element("#field-7-2")
    |> render_click()
  end
end
