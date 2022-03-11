defmodule MeepleWeb.EntryLive.IndexTest do
  use MeepleWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Meeple.Service.Admin

  setup do
    :ok = Phoenix.PubSub.subscribe(Meeple.PubSub, "GameSession")
    Admin.execute(:create, name: "test")
  end

  test "got to current board", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "<h1>Meeple</h1>"

    {:ok, _view, html} = live(conn)
    assert html =~ "<h1>Meeple</h1>"
  end

  test "create a new board", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    view
    |> element("a", "Create Board Test")
    |> render_click()

    assert_redirect(view, "/board")
  end
end
