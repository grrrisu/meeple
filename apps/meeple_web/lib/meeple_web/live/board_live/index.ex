defmodule MeepleWeb.BoardLive.Index do
  use MeepleWeb, :live_view

  alias MeepleWeb.BoardLive.{Map, Pawns, Location}

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>The Board</h1>
      <.live_component module={Pawns} id="pawns" />
      <.live_component module={Map} id="map" />
      <.live_component module={Location} id="location" />
    </div>
    """
  end
end
