defmodule MeepleWeb.BoardLive.IndexTest do
  use MeepleWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Meeple.Territory

  setup do
    Territory.create("test")
    :ok
  end

  test "got to current board", %{conn: conn} do
    conn = get(conn, "/board")
    assert html_response(conn, 200) =~ "The Board"

    {:ok, _view, html} = live(conn)
    assert html =~ "The Board"
  end

  test "create a new board", %{conn: conn} do
    assert {:error, {:redirect, %{to: "/board"}}} = live(conn, "/board/test")
    {:ok, _view, html} = live(conn, "/board")
    assert html =~ "The Board"
  end
end
