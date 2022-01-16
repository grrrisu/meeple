defmodule MeepleWeb.BoardLive.Index do
  use MeepleWeb, :live_view

  require Logger

  alias Meeple.{FogOfWar, Territory}
  alias MeepleWeb.BoardLive.{Map, FieldCard, Pawns, Location}

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, session, socket) do
    socket = assign(socket, fog_of_war: true, map_dimensions: map_dimensions())
    {:noreply, handle_action(socket.assigns.live_action, params, session, socket)}
  end

  def handle_action(:index, _params, _session, socket) do
    case map_exists?() do
      false ->
        socket
        |> put_flash(:error, "no board created or loaded")
        |> redirect(to: "/")

      _ ->
        socket
    end
  end

  def handle_action(:create, %{"territory" => territory}, _session, socket) do
    create_territory(territory)

    socket
    |> put_flash(:info, "board #{territory} created")
    |> redirect(to: "/board")
  end

  def render(assigns) do
    ~H"""
    <div class="board">
      <div class="board-header">
        <h1>The Board</h1>
        <.admin_view_switch fog_of_war={@fog_of_war} />
      </div>
      <div class="board-menu">
        <a href="/">&lt; Back</a>
      </div>
      <div class="board-map border-8 border-gray-900">
        <div>Sunny</div>
        <.live_component module={Map} id="map" dimensions={@map_dimensions} fog_of_war={@fog_of_war} />
      </div>
      <.live_component module={Pawns} id="pawns" />
      <.live_component module={Location} id="location" />
    </div>
    """
  end

  def admin_view_switch(assigns) do
    ~H"""
    <div class="grid justify-items-end">
      <div style="width: 160px">
        <form id="form-admin-view" phx-change="toggle-admin-view">
          <.slider_checkbox label="Fog of War" checked={@fog_of_war} />
        </form>
      </div>
    </div>
    """
  end

  def handle_event("toggle-admin-view", %{"slider-value" => "on"}, socket) do
    Logger.info("slider value: on")

    {:noreply,
     socket |> push_event("map_changed", %{fog_of_war: true}) |> assign(fog_of_war: true)}
  end

  def handle_event("toggle-admin-view", _slider_off, socket) do
    Logger.info("slider value: OFF!")

    {:noreply,
     socket |> push_event("map_changed", %{fog_of_war: false}) |> assign(fog_of_war: false)}
  end

  defp map_exists?() do
    Territory.exists?()
  end

  defp map_dimensions() do
    Territory.dimensions()
  end

  defp create_territory(name) do
    :ok = FogOfWar.create(name)
    :ok = Territory.create(name)
  end
end
