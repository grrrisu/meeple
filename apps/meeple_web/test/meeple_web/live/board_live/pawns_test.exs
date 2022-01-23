defmodule MeepleWeb.BoardLive.PawnsTest do
  use MeepleWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Meeple.Territory

  setup do
    Territory.create("test")
    :ok
  end

  # test "setup board", %{conn: conn} do
  #   {:ok, view, _html} = live(conn, "/board")
  #   assert view |> has_element?("#pawns")
  # end
end
