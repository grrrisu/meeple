defmodule MeepleWeb.BoardLive.Map do
  use MeepleWeb, :live_component
  require Logger

  alias Meeple.Board
  alias MeepleWeb.BoardLive.{Field, FieldCard}

  def update(assigns, socket) do
    {width, height} = Board.map_dimensions()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(
       fields: Board.get_grid(assigns.fog_of_war),
       hour: Board.get_hour(),
       width: width,
       height: height,
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
      <.top_map hour={@hour}/>
      <div class="justify-self-end"><i class="las la-caret-left la-3x "></i></div>
      <.inner_map
        width={@width}
        height={@height}
        fields={@fields}
        target={@myself}
        field_detail={@field_detail}
        detail_x={@detail_x}
        detail_y={@detail_y}/>
      <div class="justify-self-start"><i class="las la-caret-right la-3x"></i></div>
      <div style="grid-column: 1 / span 3">
        <i class="las la-caret-down la-3x"></i>
      </div>
    </div>
    """
  end

  def top_map(assigns) do
    ~H"""
    <div></div>
    <div class="w-full grid place-items-stretch" style="grid-template-columns: 1fr 50px 1fr">
      <div class="text-white">Sunny</div>
      <div>
        <i class="las la-caret-up la-3x"></i>
      </div>
      <.timeline hour={@hour}/>
    </div>
    <div></div>
    """
  end

  def timeline(assigns) do
    bottom =
      cond do
        assigns.hour == 0 || assigns.hour == 11 -> -35
        assigns.hour == 1 || assigns.hour == 10 -> -15
        assigns.hour == 2 || assigns.hour == 9 -> 0
        assigns.hour == 3 || assigns.hour == 8 -> 5
        assigns.hour == 4 || assigns.hour == 7 -> 15
        assigns.hour == 5 || assigns.hour == 6 -> 25
        true -> 0
      end

    assigns = assign(assigns, bottom: bottom)

    ~H"""
    <div id="map-hour-timeline" class="w-full h-4/5 overflow-hidden relative grid" style="grid-template-columns: repeat(12, 1fr)">
      <div class="absolute transition-all duration-[1000ms]" style={"bottom: #{@bottom}%; left: #{@hour/12 * 100}%"}>
        <img style="margin-left: 8px; width: 30px" src="/images/ui/sun_symbol.svg" />
      </div>
      <%= for i <- 0..11 do %>
        <div class="mx-0.5 py-2 text-center text-steelblue-500 bg-steelblue-300 rounded-xl">
          <%= if i != @hour do %>
            <span class="py-3"><%= i + 1 %></span>
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end

  def inner_map(assigns) do
    ~H"""
    <div
      class="grid place-content-center relative border-t border-l border-b-2 border-r-2 border-gray-900"
      style={css_grid_template(@width, @height)}>
      <%= for field <- @fields do %>
        <Field.field field={field} target={@target} />
      <% end %>
      <.live_component module={FieldCard} id="field-card" field={@field_detail} x={@detail_x} y={@detail_y}/>
    </div>
    """
  end

  def css_grid_template(width, height) do
    "grid-template-columns: repeat(#{width}, 75px); grid-template-rows: repeat(#{height}, 75px)"
  end

  def handle_event("show", %{"x" => x, "y" => y}, socket) do
    Logger.debug("show [#{x}, #{y}]")
    field = Board.get_field(x, y, socket.assigns.fog_of_war)

    {:noreply,
     assign(socket,
       field_detail: field,
       detail_x: x,
       detail_y: y
     )}
  end
end
