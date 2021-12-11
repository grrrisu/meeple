defmodule MeepleWeb.Dev.PageController do
  use MeepleWeb, :controller

  def colors(conn, _params) do
    render(conn, "colors.html")
  end
end
