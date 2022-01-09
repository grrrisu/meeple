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
      style="width: 300px; top: 30px; right: 210px"
      x-show="showFieldCard" x-cloak
      x-transition:leave="transition ease-in duration-200"
      x-transition:leave-start="opacity-100 scale-100"
      x-transition:leave-end="opacity-0 scale-75">
      <div class="border border-gray-800" style="height: 448px">
        <%= render_slot(@inner_block, @innerfield) %>
        <div @click="showFieldCard = false" class="text-center">close</div>
      </div>
    </div>
    """
  end
end
