defmodule MeepleWeb.BoardLive.Map do
  use MeepleWeb, :live_component
  require Logger

  alias Phoenix.LiveView.JS

  alias Meeple.Board

  import MeepleWeb.BoardLive.FieldHelper
  alias MeepleWeb.BoardLive.FieldCard

  def update(assigns, socket) do
    {width, height} = assigns.dimensions

    {:ok,
     socket
     |> assign(assigns)
     |> assign(
       fields: get_grid(assigns.fog_of_war),
       width: width,
       height: height,
       field_detail: nil,
       detail_x: 0,
       detail_y: 0
     )}
  end

  defp get_grid(fog_of_war) do
    Board.get_grid(fog_of_war)
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
        <%= for field <- @fields do %>
          <.field field={field} myself={@myself} />
        <% end %>
        <.live_component module={FieldCard} id="field-card" field={@field_detail} x={@detail_x} y={@detail_y}/>
      </div>
      <div class="justify-self-start"><i class="las la-caret-right la-3x"></i></div>
      <div style="grid-column: 1 / span 3"><i class="las la-caret-down la-3x"></i></div>
    </div>
    """
  end

  def field_id({x, y, _}) do
    "field-#{x}-#{y}"
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

  def fade_in(x, y, target) do
    JS.push("show", value: %{x: x, y: y}, target: target)
    |> JS.show(
      transition: {"ease-out duration-500", "opacity-25", "opacity-100"},
      to: "#field-card"
    )
  end

  def field(assigns) do
    {x, y, field} = assigns.field

    assigns =
      assigns
      |> assign(x: x, y: y)
      |> assign(vegetation: field[:vegetation])
      |> assign(building: field[:building])
      |> assign(flora: field[:flora] && Enum.join(field[:flora], ": "))
      |> assign(fauna: (field[:herbivore] || field[:predator] || []) |> Enum.join(": "))

    ~H"""
    <div
      id={"field-#{@x}-#{@y}"}
      class="field text-[0.5rem]"
      @click="showFieldCard = true"
      phx-click={fade_in(@x, @y, @myself)}
      title={"v: #{@vegetation}\nf: #{@flora}\na: #{@fauna}"}>
      <%= cond do %>
        <% @building -> %>
          <image src="/images/fields/homebase.svg" class="w-full"/>
        <% @vegetation -> %>
          <image src={"/images/fields/#{vegetation_image(@vegetation)}"} class="w-full"/>
        <% true -> %>
      <% end %>
    </div>
    """
  end
end
