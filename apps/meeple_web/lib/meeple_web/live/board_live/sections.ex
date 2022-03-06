defmodule MeepleWeb.BoardLive.Sections do
  use MeepleWeb, :component

  alias MeepleWeb.BoardLive.{AdminToolbar, HourTimeline}

  def header(assigns) do
    ~H"""
    <div style="grid-area: header">
      <h1>Meeple Board</h1>
    </div>
    """
  end

  def nav(assigns) do
    ~H"""
    <div style="grid-area: nav">
      <a href="/">&lt; Back</a>
    </div>
    """
  end

  def admin_toolbar(assigns) do
    ~H"""
    <div style="grid-area: admin">
      <AdminToolbar.render fog_of_war={@fog_of_war} />
    </div>
    """
  end

  def board_map(assigns) do
    ~H"""
    <div class="board-map border-8 border-gray-900 bg-steelblue-400 text-gray-500" style="grid-area: map">
      <div
        class="mt-4 board-map grid place-items-center"
        style="grid-template-columns: 70px auto 70px; grid-template-rows: 40px auto 40px;">
        <div></div>
        <%= render_slot(@top) %>
        <div></div>
        <div class="justify-self-end"><i class="las la-caret-left la-3x "></i></div>
        <div class="relative" x-data="{showFieldCard: false}">
          <%= render_slot(@inner_block) %>
        </div>
        <div class="justify-self-start"><i class="las la-caret-right la-3x"></i></div>
        <div></div>
        <%= render_slot(@bottom) %>
        <%= render_slot(@bottom_right) %>
      </div>
    </div>
    """
  end

  def map_top(assigns) do
    ~H"""
    <div
      class="w-full h-12 mb-2 grid place-items-stretch items-center"
      style="grid-template-columns: 1fr 1fr 1fr 75px 3fr">
      <div class="text-white">Spring</div>
      <div class="text-white">Day 1</div>
      <div class="text-white">Sunny</div>
      <div class="place-self-center">
        <i class="las la-caret-up la-3x"></i>
      </div>
      <HourTimeline.map hour={@hour}/>
    </div>
    """
  end

  def map_bottom(assigns) do
    ~H"""
    <div><i class="las la-caret-down la-3x"></i></div>
    """
  end

  def map_bottom_right(assigns) do
    ~H"""
    <div phx-click="toggle_running" phx-value-running={@running}>
      <i class="las la-caret-right la-3x"></i>
    </div>
    """
  end

  def plan(assigns) do
    ~H"""
    <div style="grid-area: plan">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  def inventory(assigns) do
    ~H"""
    <div style="grid-area: inventory">
      inventory
    </div>
    """
  end

  def xp_pool(assigns) do
    ~H"""
    <div style="grid-area: xp-pool">
      XP-Pool
    </div>
    """
  end

  def technology(assigns) do
    ~H"""
    <div style="grid-area: technology">
      Technology
    </div>
    """
  end
end
