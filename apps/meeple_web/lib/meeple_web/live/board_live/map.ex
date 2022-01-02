defmodule MeepleWeb.BoardLive.Map do
  use MeepleWeb, :live_component
  require Logger

  alias Sim.Grid
  alias Meeple.Territory

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
    [x, y] = [String.to_integer(x), String.to_integer(y)]
    field = Territory.discover(x, y)
    new_terriory = Grid.put(socket.assigns.territory, x, y, field)
    {:noreply, assign(socket, territory: new_terriory)}
  end

  def field(assigns) do
    f = Grid.get(assigns.territory, assigns.x, assigns.y)

    ~H"""
    <div
      class="field text-[0.5rem]" id={"field-#{assigns.x}-#{assigns.y}"}
      phx-click="discover" phx-value-x={assigns.x} phx-value-y={assigns.y} phx-target={@myself}>
      <%= cond do %>
        <% f[:building] -> %>
          <image src="/images/fields/homebase.svg" class="w-full"/>
        <% f[:vegetation] -> %>
          <image src={"/images/fields/#{vegetation_image(f[:vegetation])}"} class="w-full"/>
        <% true -> %>
      <% end %>
    </div>
    """
  end

  defp vegetation_image(:high_mountains), do: "high_mountains.svg"
  defp vegetation_image(:mountains), do: "mountains.svg"
  defp vegetation_image(:hills), do: "hills.svg"
  defp vegetation_image(:woods), do: "woods.svg"
  defp vegetation_image(:planes), do: "planes.svg"
  defp vegetation_image(:swamps), do: "swamps.svg"
  defp vegetation_image(:lake), do: "lake.svg"
  defp vegetation_image(_any), do: "unknown.svg"
end
