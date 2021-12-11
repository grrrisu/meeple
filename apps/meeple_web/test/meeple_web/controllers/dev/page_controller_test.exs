defmodule MeepleWeb.Dev.PageControllerTest do
  use MeepleWeb.ConnCase

  test "GET /colors", %{conn: conn} do
    conn = get(conn, "/dev/colors")
    assert html_response(conn, 200) =~ "Colors"
  end
end
