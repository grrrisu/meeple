defmodule MeepleWeb.BoardLive.Index do
  use MeepleWeb, :live_view

  alias MeepleWeb.BoardLive.Map

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>The Board</h1>
      <.live_component module={Map} id="map" />
    </div>
    """
  end
end
