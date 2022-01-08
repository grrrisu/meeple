defmodule MeepleWeb.BoardLive.FieldCard do
  use MeepleWeb, :live_component
  require Logger

  alias MeepleWeb.BoardLive.Map

  def render(%{field: nil} = assigns) do
    ~H"""
    <div>
      <.card_border let={nil} innerfield={nil}>
        <div class="border border-gray-800" style="height: 450px">
          loading ...
        </div>
      </.card_border>
    </div>
    """
  end

  def render(%{field: f} = assigns) do
    ~H"""
    <div>
      <.card_border let={field} innerfield={f}>
        <div class="border border-gray-800">
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
      :class="showFieldCard || 'hidden'"
      x-cloak
      style="width: 300px; top: 30px; right: 210px">
      <%= render_slot(@inner_block, @innerfield) %>
    </div>
    """
  end
end
