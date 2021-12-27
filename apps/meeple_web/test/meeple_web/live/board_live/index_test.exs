defmodule MeepleWeb.BoardLive.IndexTest do
  use MeepleWeb.ConnCase
  import Phoenix.LiveViewTest

  test "setup board", %{conn: conn} do
    conn = get(conn, "/board/test")
    assert html_response(conn, 200) =~ "The Board"

    {:ok, _view, html} = live(conn)
    assert html =~ "The Board"
  end
end
