defmodule MeepleWeb.BoardLive.FieldCard do
  use MeepleWeb, :live_component
  require Logger

  alias Meeple.{Action, Board, Pawn}
  import MeepleWeb.BoardLive.FieldHelper

  def render(%{field: nil} = assigns) do
    ~H"""
    <div id="field-card">
      <.card_border x={@x} y={@y}>
        <div>...loading</div>
      </.card_border>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div id="field-card" class="z-10">
      <.card_border x={@x} y={@y}>
        <div class="mt-5" style="height: 392px">
          <.card_title title={@field[:building] || @field[:vegetation] || :"Terra Incognita"} />
          <div class="my-2 mx-auto grid justify-center bg-steelbluex-100">
            <img
              src={"/images/fields/#{(@field[:building] && "homebase.svg") || vegetation_image(@field[:vegetation])}"}
              class="border border-steelblue-800"
              style="height: 240px"/>
          </div>
          <div class="px-3 text-sm">
            <p class="italic">
              Description: <%= @field[:vegetation] %>
            </p>
            <p>
              <%= if @field[:flora] do %>
                Flora: <%= @field[:flora] |> inspect() %><br/>
              <% end %>
              <%= if @field[:herbivore] do %>
                Herbivores: <%= @field[:herbivore] |> inspect() %><br/>
              <% end %>
              <%= if @field[:predator] do %>
                Predators: <%= @field[:predator] |> inspect() %><br/>
              <% end %>
              <%= if @field[:danger] do %>
                Danger: <%= @field[:danger] |> inspect() %><br/>
              <% end %>
              <%= if @field[:pawns] do %>
                Pawns: <%= @field[:pawns] |> inspect() %><br/>
              <% end %>
            </p>
            <.action_list field={@field} x={@x} y={@y} target={@myself} />
          </div>
        </div>
      </.card_border>
    </div>
    """
  end

  def card_border(%{x: x} = assigns) do
    left =
      if x <= 7 do
        (x + 1) * 75 + 20
      else
        (x - 4) * 75 - 20
      end

    ~H"""
    <div
      id="field-card-border"
      class="bg-gray-50 rounded-lg drop-shadow-md border border-gray-800 p-4 absolute transition-all duration-500 ease-out"
      style={"width: 300px; top: 30px; left: #{left}px"}
      x-show="showFieldCard" x-cloak
      @close="showFieldCard = false"
      x-transition:enter="transition ease-out duration-300"
      x-transition:enter-start="opacity-0 scale-90"
      x-transition:enter-end="opacity-100 scale-100"
      x-transition:leave="transition ease-in duration-200"
      x-transition:leave-start="opacity-100 scale-100"
      x-transition:leave-end="opacity-0 scale-75"
      phx-hook="FieldCard">
      <div class="border border-gray-800" style="height: 448px">
        <%= render_slot(@inner_block) %>
        <.card_close_button text="close" />
      </div>
    </div>
    """
  end

  def card_title(assigns) do
    title =
      assigns.title
      |> Atom.to_string()
      |> String.capitalize()

    ~H"""
    <div class="text-center font-bold absolute text-steelblue-800"
      style="width: 280px; height: 30px; top: 13px; right: 10px; background-image: url('/images/ui/card_title.svg'); background-size: 280px 30px">
      <h2 class="pt-1"><%= title %></h2>
    </div>
    """
  end

  def card_close_button(assigns) do
    click_event = (Map.get(assigns, :click) && assigns.click) || []

    ~H"""
    <div class="grid justify-center">
      <div class="text-center text-steelblue-800 pt-0.5"
        style="width: 159px; height: 30px; top: 13px; right: 10px; background-image: url('/images/ui/button.svg'); background-size: 159px 30px"
        {click_event}
        @click="showFieldCard = false">
        <%= @text %>
      </div>
    </div>
    """
  end

  def action_list(%{field: %{vegetation: _vegetation}} = assigns) do
    ~H"""
    <div>
      Actions available ....<br/>
      Option 1 <br/>
      Option 2 <br/>
      Option 3 <br/>
    </div>
    """
  end

  def action_list(assigns) do
    path_costs = abs(7 - assigns.x) + abs(1 - assigns.y)

    click = [
      "phx-click": "discover",
      "phx-target": assigns.target,
      "phx-value-x": assigns.x,
      "phx-value-y": assigns.y
    ]

    ~H"""
    <div>
      <p>
      Path costs: <%= path_costs %>
      </p>
      Actions available:<br/>
      <.card_close_button text="Discover" click={click} />
    </div>
    """
  end

  def handle_event("discover", %{"x" => x, "y" => y}, socket) do
    Logger.debug("discover [#{x}, #{y}]")
    {x, y} = {String.to_integer(x), String.to_integer(y)}

    %Action{name: :discover, pawn: %Pawn{id: 1, x: 7, y: 1}, points: 4, x: x, y: y}
    |> Board.add_action()

    {:noreply, socket}
  end
end
