defmodule MeepleWeb.BoardLive.Map do
  use MeepleWeb, :live_component
  require Logger

  alias Phoenix.LiveView.JS

  alias Sim.Grid
  alias Meeple.Territory

  alias MeepleWeb.BoardLive.FieldCard

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(
       width: Grid.width(assigns.territory),
       height: Grid.height(assigns.territory),
       field_detail: nil,
       detail_x: 0,
       detail_y: 0
     )}
  end

  def render(assigns) do
    # for now we a use the container width lx of 1280px
    # https://tailwindcss.com/docs/container
    ~H"""
    <div id="map"
      x-data="{showFieldCard: false}"
      class="board-map grid place-items-center text-gray-500"
      style="grid-template-columns: 70px auto 70px; grid-template-rows: 40px auto 40px;">
      <div style="grid-column: 1 / span 3"><i class="las la-caret-up la-3x"></i></div>
      <div class="justify-self-end"><i class="las la-caret-left la-3x "></i></div>
      <div
        class="grid place-content-center relative"
        style={css_grid_template(@width, @height)}>
        <%= for y <- (@height - 1)..0 do %>
          <%= for x <- 0..(@width - 1) do %>
            <.field x={x} y={y} territory={@territory} myself={@myself} />
          <% end %>
        <% end %>
        <.live_component module={FieldCard} id="field-card" field={@field_detail} x={@detail_x} y={@detail_y}/>
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
    field = Territory.discover(x, y)
    new_terriory = Grid.put(socket.assigns.territory, x, y, field)

    {:noreply,
     assign(socket, territory: new_terriory, field_detail: field, detail_x: x, detail_y: y)}
  end

  def fade_in(x, y, target) do
    JS.push("discover", value: %{x: x, y: y}, target: target)
    |> JS.show(
      transition: {"ease-out duration-500", "opacity-25", "opacity-100"},
      to: "#field-card"
    )
  end

  def field(assigns) do
    f = Grid.get(assigns.territory, assigns.x, assigns.y)
    flora = f[:flora] && Enum.join(f[:flora], ": ")
    fauna = (f[:herbivore] || f[:predator] || []) |> Enum.join(": ")

    ~H"""
    <div
      id={"field-#{@x}-#{@y}"}
      class="field text-[0.5rem]"
      @click="showFieldCard = true"
      phx-click={fade_in(@x, @y, @myself)}
      title={"v: #{f[:vegetation]}\nf: #{flora}\na: #{fauna}"}>
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

  def vegetation_image(:high_mountains), do: "high_mountains.svg"
  def vegetation_image(:mountains), do: "mountains.svg"
  def vegetation_image(:hills), do: "hills.svg"
  def vegetation_image(:woods), do: "woods.svg"
  def vegetation_image(:planes), do: "planes.svg"
  def vegetation_image(:swamps), do: "swamps.svg"
  def vegetation_image(:lake), do: "lake.svg"
  def vegetation_image(_any), do: "unknown.svg"
end
