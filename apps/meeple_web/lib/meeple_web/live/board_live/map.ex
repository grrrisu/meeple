defmodule MeepleWeb.BoardLive.Map do
  use MeepleWeb, :live_component

  alias Sim.Grid

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(width: Grid.width(assigns.territory), height: Grid.height(assigns.territory))}
  end

  def render(assigns) do
    # for now we a use the container width lx of 1280px
    # https://tailwindcss.com/docs/container
    ~H"""
    <div id="map" class="board-map grid place-items-center text-gray-500"
      style="grid-template-columns: 70px auto 70px; grid-template-rows: 40px auto 40px;">
      <div style="grid-column: 1 / span 3"><i class="las la-caret-up la-3x"></i></div>
      <div class="justify-self-end"><i class="las la-caret-left la-3x "></i></div>
      <div
        class="grid place-content-center"
        style={css_grid_template(@width, @height)}>
        <%= for y <- (@height - 1)..0 do %>
          <%= for x <- 0..(@width - 1) do %>
            <.field x={x} y={y} territory={@territory} />
          <% end %>
        <% end %>
      </div>
      <div class="justify-self-start"><i class="las la-caret-right la-3x"></i></div>
      <div style="grid-column: 1 / span 3"><i class="las la-caret-down la-3x"></i></div>
    </div>
    """
  end

  def css_grid_template(width, height) do
    "grid-template-columns: repeat(#{width}, 75px); grid-template-rows: repeat(#{height}, 75px)"
  end

  def field(assigns) do
    ~H"""
    <div class="field" id={"field-#{assigns.x}-#{assigns.y}"}>
      [<%= assigns.x %>,<%= assigns.y %>]
      <br/>
      <span class="text-xs">
        <%= vegetation_type(assigns.territory, assigns.x, assigns.y) %>
      </span>
    </div>
    """
  end

  def vegetation_type(territory, x, y) do
    Grid.get(territory, x, y) |> inspect()
  end
end
