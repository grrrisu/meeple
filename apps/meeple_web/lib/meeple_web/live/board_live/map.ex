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
      <div style="grid-column: 1 / span 3"><i class="las la-caret-up la-3x"></i></div>
      <div class="justify-self-end"><i class="las la-caret-left la-3x "></i></div>
      <div
        class="grid place-content-center relative border-t border-l border-b-2 border-r-2 border-gray-900"
        style={css_grid_template(@width, @height)}>
        <%= for field <- @fields do %>
          <Field.field field={field} target={@myself} />
        <% end %>
        <.live_component module={FieldCard} id="field-card" field={@field_detail} x={@detail_x} y={@detail_y}/>
      </div>
      <div class="justify-self-start"><i class="las la-caret-right la-3x"></i></div>
      <div style="grid-column: 1 / span 3">
        <i class="las la-caret-down la-3x"></i>
      </div>
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
