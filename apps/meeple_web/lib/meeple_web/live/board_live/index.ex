defmodule MeepleWeb.BoardLive.Index do
  use MeepleWeb, :live_view

  require Logger

  alias Meeple.Board
  alias MeepleWeb.BoardLive.{AdminToolbar, Map, Plan}

  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe()
    {:ok, socket}
  end

  def handle_params(params, session, socket) do
    socket = assign(socket, fog_of_war: true)
    {:noreply, handle_action(socket.assigns.live_action, params, session, socket)}
  end

  def handle_action(:index, _params, _session, socket) do
    case Board.map_exists?() do
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
        <AdminToolbar.render fog_of_war={@fog_of_war} />
      </div>
      <div class="board-menu">
        <a href="/">&lt; Back</a>
      </div>
      <div class="board-map border-8 border-gray-900 bg-steelblue-400">
        <.live_component module={Map} id="map" fog_of_war={@fog_of_war} />
        <div class="mx-16 py-3 grid justify-start grid-cols-10">
          <div class="bg-steelblue-300 mx-auto p-2 rounded-lg">
            <div style="width: 40px; height: 40px">
              <img src="/images/ui/human_symbol.svg" class="w-full"/>
            </div>
            <span class="text-sm text-copperfield-900 font-bold">5 / 12</span>
          </div>
          <div class="bg-steelblue-300 mx-auto p-2 rounded-lg">
            <div style="width: 40px; height: 40px">
              <img src="/images/ui/human_symbol2.svg" class="w-full"/>
            </div>
            <span class="text-sm text-copperfield-900 font-bold">10 / 12</span>
          </div>
          <div style="width: 50px; height: 50px">
            <img src="/images/ui/human_token_dark.svg" class="w-full"/>
          </div>
        </div>
      </div>
    </div>
    <.live_component module={Plan} id="plan" />
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

  def handle_event("clear-plan", _params, socket) do
    Logger.info("claer-plan")
    :ok = Board.clear_plan()
    {:noreply, socket}
  end

  def handle_event("next-hour", _params, socket) do
    Logger.info("claer-plan")
    :ok = Board.next_hour()
    {:noreply, socket}
  end

  def handle_info({:field_discovered, %{x: _x, y: _y}}, socket) do
    Logger.info("field discovered")
    update_map(socket)
    {:noreply, socket}
  end

  def handle_info({:grid_updated}, socket) do
    Logger.info("grid updated")
    update_map(socket)
    {:noreply, socket}
  end

  def handle_info({:plan_updated}, socket) do
    Logger.info("plan updated")
    update_plan(socket)
    {:noreply, socket}
  end

  def handle_info({:hour_updated}, socket) do
    Logger.info("hour updated")
    update_map(socket)
    update_plan(socket)
    {:noreply, socket}
  end

  def handle_info(_ignore, socket) do
    Logger.info("ignore")
    {:noreply, socket}
  end

  defp update_map(socket) do
    send_update(Map,
      id: "map",
      fog_of_war: socket.assigns.fog_of_war
    )
  end

  defp update_plan(_socket) do
    send_update(Plan, id: "plan")
  end

  defp subscribe() do
    Phoenix.PubSub.subscribe(Meeple.PubSub, "GameSession")
  end

  defp create_territory(name) do
    Board.create(name)
  end
end
