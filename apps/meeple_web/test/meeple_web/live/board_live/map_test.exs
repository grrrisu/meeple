defmodule MeepleWeb.BoardLive.MapTest do
  use MeepleWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Meeple.Service.Admin

  setup do
    Admin.execute(:create, name: "test")
  end

  test "setup board", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")
    assert view |> has_element?("#map")
  end

  test "field", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")
    assert view |> element("#field-1-1") |> render() =~ "homebase.svg"
  end

  test "discover", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")

    view
    |> element("#field-1-2")
    |> render_click()

    assert view |> element("#field-card") |> render() =~ "Discover"
  end

  test "show clicked field details", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")

    view
    |> element("#field-1-1")
    |> render_click()

    assert view |> element("#field-card") |> render() =~ "Headquarter"
  end

  test "toggle fog of war", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")
    refute view |> element("#field-0-3") |> render() =~ "planes.svg"

    view
    |> element("#form-admin-view")
    |> render_change(%{})

    assert view |> element("#field-0-3") |> render() =~ "planes.svg"

    view |> element("#form-admin-view") |> render_change(%{"slider-value" => "on"})
    refute view |> element("#field-0-3") |> render() =~ "planes.svg"
  end

  test "hour timeline", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")
    assert view |> element("#map-hour-timeline") |> render() =~ "sun_symbol.svg"
  end
end
