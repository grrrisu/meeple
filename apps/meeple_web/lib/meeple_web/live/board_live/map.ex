defmodule MeepleWeb.BoardLive.Map do
  use MeepleWeb, :live_component

  def render(assigns) do
    # for now we a use the container width lx of 1280px
    # https://tailwindcss.com/docs/container
    ~H"""
    <div
      id="map"
      class="board-map grid place-content-center"
      style="grid-template-columns: repeat(15, 75px); grid-template-rows: repeat(7, 75px)">
      <%= for _row <- 0..6 do %>
        <%= for _column <- 0..14 do %>
          <div class="field"></div>
        <% end %>
      <% end %>
    </div>
    """
  end
end
