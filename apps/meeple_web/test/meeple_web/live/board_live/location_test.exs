defmodule MeepleWeb.BoardLive.LocationTest do
  use MeepleWeb.ConnCase
  import Phoenix.LiveViewTest

  test "setup board", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/board")
    view |> element("#location") |> has_element?()
  end
end
