defmodule MeepleWeb.BoardLive.FieldCard do
  use MeepleWeb, :live_component
  require Logger

  alias MeepleWeb.BoardLive.Map

  def render(%{field: nil} = assigns) do
    ~H"""
    <div>
      <.card_border let={nil} innerfield={nil} x={@x} y={@y}>
        loading ...
      </.card_border>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div>
      <.card_border x={@x} y={@y}>
        <div class="mt-5" style="height: 392px">
          <.card_title title={@field[:building] || @field[:vegetation]} />
          <div class="my-2 mx-auto grid justify-center bg-steelbluex-100">
            <image
              src={"/images/fields/#{(@field[:building] && "homebase.svg") || Map.vegetation_image(@field[:vegetation])}"}
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
            </p>
            <div>
              Actions available ....<br/>
              Option 1 <br/>
              Option 2 <br/>
              Option 3 <br/>
            </div>
          </div>
        </div>
      </.card_border>
    </div>
    """
  end

  def card_border(assigns) do
    left =
      if assigns.x <= 7 do
        (assigns.x + 1) * 75 + 20
      else
        (assigns.x - 4) * 75 - 20
      end

    ~H"""
    <div
      id="field-card"
      class="bg-gray-50 rounded-lg drop-shadow-md border border-gray-800 p-4 absolute transition-all duration-500 ease-out"
      style={"width: 300px; top: 30px; left: #{left}px"}
      x-show="showFieldCard" x-cloak
      x-transition:leave="transition ease-in duration-200"
      x-transition:leave-start="opacity-100 scale-100"
      x-transition:leave-end="opacity-0 scale-75">
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
    ~H"""
    <div class="grid justify-center">
      <div class="text-center text-steelblue-800 pt-0.5"
        style="width: 159px; height: 30px; top: 13px; right: 10px; background-image: url('/images/ui/button.svg'); background-size: 159px 30px"
        @click="showFieldCard = false">
        <%= @text %>
      </div>
    </div>
    """
  end
end
