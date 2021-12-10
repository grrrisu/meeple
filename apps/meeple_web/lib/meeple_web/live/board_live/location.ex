defmodule MeepleWeb.BoardLive.Location do
  use MeepleWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="location" class="board-location">location details go here</div>
    """
  end
end
