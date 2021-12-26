defmodule MeepleWeb.BoardLive.Map do
  use MeepleWeb, :live_component
  require Logger

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
            <.field x={x} y={y} territory={@territory} myself={@myself} />
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

  def handle_event("discover", %{"x" => x, "y" => y}, socket) do
    Logger.debug("discover [#{x}, #{y}]")
    {:noreply, socket}
  end

  def field(assigns) do
    f = Grid.get(assigns.territory, assigns.x, assigns.y)

    ~H"""
    <div
      class="field text-[0.5rem]" id={"field-#{assigns.x}-#{assigns.y}"}
      phx-click="discover" phx-value-x={assigns.x} phx-value-y={assigns.y} phx-target={@myself}>
      [<%= assigns.x %>,<%= assigns.y %>]
      <br/>
      <%= f[:vegetation] %>
      <br/>
      <%= f[:building] %>
      <%= f[:flora] && List.first(f[:flora]) %>
      <br/>
      <%= f[:herbivore] && List.first(f[:herbivore]) %>
      <br />
      <%= f[:predator] && List.first(f[:predator]) %>
      <br />
    </div>
    """
  end
end
