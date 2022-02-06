defmodule MeepleWeb.BoardLive.Index do
  use MeepleWeb, :live_view

  require Logger

  import MeepleWeb.BoardLive.Sections

  alias Meeple.Board
  alias MeepleWeb.BoardLive.{Map, Plan}

  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe()
    {:ok, socket}
  end

  def handle_params(params, session, socket) do
    socket =
      assign(socket,
        fog_of_war: true,
        fields: get_fields(true),
        pawns: get_pawns(),
        hour: Board.get_hour()
      )

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
      <.header />
      <.nav />
      <.admin_toolbar fog_of_war={@fog_of_war}/>
      <.board_map>
        <:top>
          <.map_top hour={@hour}/>
        </:top>
        <.live_component module={Map}
          id="map"
          fog_of_war={@fog_of_war}
          fields={@fields}
          pawns={@pawns}
          selected_pawn={1}/>
        <:bottom>
          <.map_bottom pawns={@pawns} />
        </:bottom>
      </.board_map>
      <.plan>
        <.live_component module={Plan} id="plan" />
      </.plan>
      <.inventory/>
      <.xp_pool />
      <.technology />
    </div>
    """
  end

  def handle_event("toggle-admin-view", %{"slider-value" => "on"}, socket) do
    Logger.info("slider value: on")

    {:noreply,
     socket
     |> push_event("map_changed", %{fog_of_war: true})
     |> assign(fog_of_war: true, fields: get_fields(true))}
  end

  def handle_event("toggle-admin-view", _slider_off, socket) do
    Logger.info("slider value: OFF!")

    {:noreply,
     socket
     |> push_event("map_changed", %{fog_of_war: false})
     |> assign(fog_of_war: false, fields: get_fields(false))}
  end

  def handle_event("clear-plan", _params, socket) do
    Logger.info("clear-plan")
    :ok = Board.clear_plan()
    {:noreply, socket}
  end

  def handle_event("next-hour", _params, socket) do
    Logger.info("next-hour")
    :ok = Board.next_hour()
    {:noreply, socket}
  end

  def handle_info({:field_discovered, %{x: _x, y: _y}}, socket) do
    Logger.info("field discovered")
    {:noreply, assign_fields(socket)}
  end

  def handle_info({:grid_updated}, socket) do
    Logger.info("grid updated")
    {:noreply, socket |> assign_fields() |> assign(pawns: get_pawns())}
  end

  def handle_info({:plan_updated}, socket) do
    Logger.info("plan updated")
    update_plan(socket)
    {:noreply, socket}
  end

  def handle_info({:hour_updated}, socket) do
    Logger.info("hour updated")
    update_plan(socket)
    {:noreply, socket |> assign_fields() |> assign(hour: Board.get_hour())}
  end

  def handle_info(_ignore, socket) do
    Logger.info("ignore")
    {:noreply, socket}
  end

  defp assign_fields(socket) do
    assign(socket, fields: get_fields(socket.assigns.fog_of_war))
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

  defp get_fields(fog_of_war) do
    Board.get_grid(fog_of_war)
  end

  defp get_pawns() do
    Board.get_pawns()
  end
end
