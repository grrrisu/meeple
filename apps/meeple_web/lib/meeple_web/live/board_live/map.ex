defmodule MeepleWeb.BoardLive.Map do
  use MeepleWeb, :live_component
  require Logger

  alias Meeple.Board
  alias MeepleWeb.BoardLive.{Field, FieldCard}

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(
       field_detail: nil,
       detail_x: 0,
       detail_y: 0
     )}
  end

  def render(assigns) do
    ~H"""
    <div id="map"
      class="grid place-content-center relative border-t border-l border-b-2 border-r-2 border-gray-900"
      style={css_grid_template(@width, @height)}>
      <%= for field <- @fields do %>
        <Field.field field={field} target={@myself} />
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
