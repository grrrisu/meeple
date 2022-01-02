defmodule MeepleWeb.PageController do
  use MeepleWeb, :controller

  alias Meeple.Territory

  def index(conn, _params) do
    territory_exists = Territory.exists?()
    render(conn, "index.html", territory_exists: territory_exists)
  end
end
