defmodule MeepleWeb.BoardLive.Inventory do
  use MeepleWeb, :live_component

  alias Meeple.Board

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(inventory: Board.get_inventory())}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div>food: <%= @inventory.food %></div>
      <div>flintstone: <%= @inventory.flintstone %></div>
    </div>
    """
  end
end
