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
    <div id="plan" class="plan-wall mt-8" style="margin-left: 80px; margin-right: 80px">
      <div class="grid grid-cols-3" style="grid-template-columns: 112px repeat(3, 90px) 112px">
        <div style="width: 112px; height: 150px;">
          <img class="w-full" src="/images/ui/wall_left.svg" />
        </div>
        <div style="width: 90px; height: 150px;">
          <img class="w-full" src="/images/ui/wall_middle.svg" />
        </div>
        <div class="relative" style="width: 90px; height: 150px;">
          <img class="w-full absolute" src="/images/ui/action_discover.svg" />
          <img class="w-full" src="/images/ui/wall_middle.svg" />
        </div>
        <div style="width: 90px; height: 150px;">
          <img class="w-full" src="/images/ui/wall_middle.svg" />
        </div>
        <div style="width: 112px; height: 150px;">
          <img class="w-full" src="/images/ui/wall_right.svg" />
        </div>
      </div>

      <div>
        <%= for action <- @plan.actions do %>
          <div class="border"><%= inspect(action) %></div>
        <% end %>
        <div class="border" phx-click="run" phx-target={@myself}>run</div>
      </div>
    </div>
    """
  end

  def handle_event("run", _params, socket) do
    Plan.tick()
    {:noreply, socket}
  end
end
