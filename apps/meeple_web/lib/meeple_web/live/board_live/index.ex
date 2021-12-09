defmodule MeepleWeb.BoardLive.Index do
  use MeepleWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>The Board</h1>
    </div>
    """
  end
end
