defmodule MeepleWeb.BoardLive.Map do
  use MeepleWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="map" class="board-map map">
    </div>
    """
  end
end
