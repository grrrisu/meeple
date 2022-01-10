defmodule MeepleWeb.BoardLive.MapTest do
  use MeepleWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Meeple.Territory

  setup do
    Territory.create("test")
    :ok
  end

  test "setup board", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")
    assert view |> has_element?("#map")
  end

  test "field", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")
    assert view |> element("#field-1-1") |> render() =~ "homebase.svg"
  end

  # skip until https://github.com/phoenixframework/phoenix_live_view/issues/1824 is relsolved
  @tag :skip
  test "discover", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")

    view
    |> element("#field-1-2")
    |> render_click()

    {:ok, view, _html} = live(conn, "/board")
    assert view |> element("#field-1-2") |> render() =~ "planes.svg"
  end

  # skip until https://github.com/phoenixframework/phoenix_live_view/issues/1824 is relsolved
  @tag :skip
  test "show clicked field details", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")

    view
    |> element("#field-1-2")
    |> render_click()

    assert view |> element("#field-card") |> render() =~ "<h2>Planes</h2>"
  end
end
