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
      <div class="grid grid-cols-3 relative" style="width: 494px; grid-template-columns: 112px repeat(10, 90px) 112px">
        <div style="width: 112px; height: 150px;">
          <img class="w-full" src="/images/ui/wall_left.svg" />
        </div>
        <%= for _i <- 1..10 do %>
          <div style="width: 90px; height: 150px;">
          <img class="w-full" src="/images/ui/wall_middle.svg" />
          </div>
        <% end %>
        <div style="width: 112px; height: 150px;">
          <img class="w-full" src="/images/ui/wall_right.svg" />
        </div>

        <%= for {action, index} <- Enum.with_index(@plan.actions) do %>
          <.action index={index} action={action} />
        <% end %>
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

  def action(assigns) do
    ~H"""
      <img style={"width: 90px; top: -10px; left: #{@index *90}px"} class="absolute" src={"/images/ui/action_#{@action.name}.svg"} />
      <img style={"width: 25px; top: 110px; left: #{@index *90 + 30}px"} class="absolute" src={"/images/ui/action_points_#{@action.points - @action.done}.svg"} />
    """
  end

  def handle_event("run", _params, socket) do
    Plan.tick()
    {:noreply, socket}
  end
end
