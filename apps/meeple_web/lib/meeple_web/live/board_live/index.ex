defmodule MeepleWeb.BoardLive.Index do
  use MeepleWeb, :live_view

  alias MeepleWeb.BoardLive.{Map, Pawns, Location}

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="board">
      <div class="board-header">
        <h1>The Board</h1>
      </div>
      <div class="board-menu">menu</div>
      <div class="board-map border-8 border-gray-900">
        <div>Sunny</div>
        <.live_component module={Map} id="map" />
      </div>
      <.live_component module={Pawns} id="pawns" />
      <.live_component module={Location} id="location" />
    </div>
    """
  end
end
