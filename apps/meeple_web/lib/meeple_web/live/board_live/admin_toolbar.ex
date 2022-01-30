defmodule MeepleWeb.BoardLive.AdminToolbar do
  use MeepleWeb, :component

  def render(assigns) do
    ~H"""
    <div class="grid justify-items-end grid-cols-3">
      <.clear_plan_button />
      <.next_hour_button />
      <.fog_of_war_switch fog_of_war={@fog_of_war} />
    </div>
    """
  end

  def fog_of_war_switch(assigns) do
    ~H"""
    <div style="width: 160px">
      <form id="form-admin-view" phx-change="toggle-admin-view">
        <.slider_checkbox label="Fog of War" checked={@fog_of_war} />
      </form>
    </div>
    """
  end

  def clear_plan_button(assigns) do
    ~H"""
    <div phx-click="clear-plan">Clear Plan</div>
    """
  end

  def next_hour_button(assigns) do
    ~H"""
    <div phx-click="next-hour">Next Hour</div>
    """
  end
end
