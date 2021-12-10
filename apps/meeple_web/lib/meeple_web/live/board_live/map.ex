defmodule MeepleWeb.BoardLive.Map do
  use MeepleWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="map">map goes here</div>
    """
  end
end
