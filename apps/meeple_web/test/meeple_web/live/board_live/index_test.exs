defmodule MeepleWeb.BoardLive.IndexTest do
  use MeepleWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Meeple.Service.Admin

  setup do
    Admin.execute(:create, name: "test")
  end

  test "got to current board", %{conn: conn} do
    conn = get(conn, "/board")
    assert html_response(conn, 200) =~ "Meeple Board"

    {:ok, _view, html} = live(conn)
    assert html =~ "Meeple Board"
  end
end
