defmodule MeepleWeb.PageController do
  use MeepleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
