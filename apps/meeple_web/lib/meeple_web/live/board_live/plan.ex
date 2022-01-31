defmodule MeepleWeb.BoardLive.Plan do
  use MeepleWeb, :live_component

  alias Meeple.{Board, Plan}
  alias MeepleWeb.BoardLive.HourTimeline

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(plan: Plan.get())
     |> assign(hour: Board.get_hour())}
  end

  def render(assigns) do
    ~H"""
    <div id="plan" class="plan-wall mt-8" style="margin-left: 80px; margin-right: 80px">
      <div class="relative">
        <HourTimeline.plan hour={@hour} />
        <%= for {action, index} <- Enum.with_index(@plan.actions) do %>
          <.action index={index} action={action} />
        <% end %>
        <div class="grid" style="grid-template-columns: 112px repeat(10, 90px) 112px">
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
        </div>
      </div>

      <div class="m-2">
        <div phx-click="next-hour">Next Hour</div>
      </div>
    </div>
    """
  end

  def action(assigns) do
    ~H"""
      <img style={"width: 90px; top: 0; left: #{@index *90}px"} class="absolute" src={"/images/ui/action_#{@action.name}.svg"} />
      <%= if @action.points - @action.done > 0 do %>
        <img style={"width: 25px; top: 110px; left: #{@index *90 + 30}px"} class="absolute" src={"/images/ui/action_points_#{@action.points - @action.done}.svg"} />
      <% end %>
    """
  end
end
