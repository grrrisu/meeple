defmodule MeepleWeb.BoardLive.Index do
  use MeepleWeb, :live_view

  require Logger

  alias Meeple.Territory
  alias MeepleWeb.BoardLive.{Map, Pawns, Location}

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(territory: load_territory())}
  end

  def handle_params(params, session, socket) do
    {:noreply, handle_action(socket.assigns.live_action, params, session, socket)}
  end

  def handle_action(:index, _params, _session, socket) do
    case socket.assigns.territory do
      nil ->
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
        <.admin_view_switch />
      </div>
      <div class="board-menu">
        <a href="/">&lt; Back</a>
      </div>
      <div class="board-map border-8 border-gray-900">
        <div>Sunny</div>
        <.live_component module={Map} id="map" territory={@territory}/>
      </div>
      <.live_component module={Pawns} id="pawns" />
      <.live_component module={Location} id="location" />
    </div>
    """
  end

  def admin_view_switch(assigns) do
    ~H"""
    <form phx-change="toggle-admin-view">
      <.slider_checkbox />
    </form>
    """
  end

  def handle_event("toggle-admin-view", %{"slider-value" => value}, socket) do
    Logger.info("slider value: #{value}")
    {:noreply, socket}
  end

  def handle_event("toggle-admin-view", _no_value, socket) do
    Logger.info("slider value: OFF!")
    {:noreply, socket}
  end

  defp load_territory() do
    Territory.get()
  end

  defp create_territory(name) do
    Territory.create(name)
  end
end
