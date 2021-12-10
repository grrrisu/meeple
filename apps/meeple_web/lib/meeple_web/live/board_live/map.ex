defmodule MeepleWeb.BoardLive.Map do
  use MeepleWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="map" class="board-map map">
      <div class="field bg-brown-50"></div>
      <div class="field bg-beige-50"></div>
      <div class="field bg-ochre-50"></div>
      <div class="field bg-olive-50"></div>
      <div class="field bg-steelblue-50"></div>
      <div class="field bg-steelblue-900"></div>
    </div>
    """
  end
end
