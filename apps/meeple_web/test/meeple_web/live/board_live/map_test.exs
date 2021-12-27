defmodule MeepleWeb.BoardLive.MapTest do
  use MeepleWeb.ConnCase
  import Phoenix.LiveViewTest

  test "setup board", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board/test")
    assert view |> has_element?("#map")
  end

  test "field", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board/test")
    assert view |> has_element?("#field-1-1", "headquarter")
  end

  test "discover", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board/test")

    view
    |> element("#field-1-2")
    |> render_click()

    {:ok, view, _html} = live(conn, "/board/test")
    assert view |> element("#field-1-2") |> render() =~ "planes"
  end
end
