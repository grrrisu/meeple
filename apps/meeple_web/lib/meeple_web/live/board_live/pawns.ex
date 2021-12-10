defmodule MeepleWeb.BoardLive.Pawns do
  use MeepleWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="pawns" class="board-pawns">pawns selection go here</div>
    """
  end
end
