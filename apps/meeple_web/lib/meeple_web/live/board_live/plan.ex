defmodule MeepleWeb.BoardLive.Plan do
  use MeepleWeb, :live_component

  alias Meeple.Plan

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(plan: Plan.get())}
  end

  def render(assigns) do
    ~H"""
    <div id="plan" class="board-pawns">
      <%= for action <- @plan.actions do %>
        <div class="border"><%= inspect(action) %></div>
      <% end %>
      <div class="border" phx-click="run" phx-target={@myself}>run</div>
    </div>
    """
  end

  def handle_event("run", _params, socket) do
    Plan.tick()
    {:noreply, assign(socket, plan: Plan.get())}
  end
end
