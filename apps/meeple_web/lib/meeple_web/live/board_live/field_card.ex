defmodule MeepleWeb.BoardLive.FieldCard do
  use MeepleWeb, :live_component
  require Logger

  alias MeepleWeb.BoardLive.Map

  def render(%{field: nil} = assigns) do
    ~H"""
    <div>
      <.card_border let={nil} innerfield={nil}>
        loading ...
      </.card_border>
    </div>
    """
  end

  def render(%{field: f} = assigns) do
    ~H"""
    <div>
      <.card_border let={field} innerfield={f}>
        <h2><%= (field[:building] || field[:vegetation]) |> Atom.to_string() |> String.capitalize() %></h2>
        <div class="" style="height: 392px">
          <div class="my-2 mx-auto">
            <image src={"/images/fields/#{(field[:building] && "homebase.svg") || Map.vegetation_image(field[:vegetation])}"} height="50"/>
          </div>
          <p>
            Description: <%= field[:vegetation] %>
          </p>
          <p>
            <%= if field[:flora] do %>
              Flora: <%= field[:flora] |> inspect() %><br/>
            <% end %>
            <%= if field[:herbivore] do %>
              Herbivores: <%= field[:herbivore] |> inspect() %><br/>
            <% end %>
            <%= if field[:predator] do %>
              Predators: <%= field[:predator] |> inspect() %><br/>
            <% end %>
            <%= if field[:danger] do %>
              Danger: <%= field[:danger] |> inspect() %><br/>
            <% end %>
          </p>
          <div>
            Actions available ....
          </div>
        </div>
      </.card_border>
    </div>
    """
  end

  def card_border(assigns) do
    ~H"""
    <div
      id="field-card"
      class="bg-gray-50 rounded-lg drop-shadow-lg border border-gray-800 p-4 absolute"
      x-show="showFieldCard" x-cloak x-transistion.duration.500ms
      style="width: 300px; top: 30px; right: 210px">
      <div class="border border-gray-800">
        <%= render_slot(@inner_block, @innerfield) %>
        <div @click="showFieldCard = false" class="text-center">close</div>
      </div>
    </div>
    """
  end
end
