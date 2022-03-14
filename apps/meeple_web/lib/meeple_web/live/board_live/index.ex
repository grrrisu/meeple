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
    {:noreply, handle_action(socket.assigns.live_action, params, session, socket)}
  end

  def handle_action(:index, _params, _session, socket) do
    case Board.map_exists?() do
      false ->
        socket
        |> put_flash(:error, "no board created or loaded")
        |> redirect(to: "/")

      _ ->
        prepare_assigns(socket)
    end
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
        <:bottom_right>
          <.map_bottom_right running={to_string(@running)} />
        </:bottom_right>
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
    Logger.info("board index slider value: on")

    {:noreply,
     socket
     |> push_event("map_changed", %{fog_of_war: true})
     |> assign(fog_of_war: true, fields: get_fields(true))}
  end

  def handle_event("toggle-admin-view", _slider_off, socket) do
    Logger.info("board index slider value: OFF!")

    {:noreply,
     socket
     |> push_event("map_changed", %{fog_of_war: false})
     |> assign(fog_of_war: false, fields: get_fields(false))}
  end

  def handle_event("clear-plan", _params, socket) do
    Logger.info("board index clear-plan")
    :ok = Meeple.clear_plan()
    {:noreply, socket}
  end

  def handle_event("next-hour", _params, socket) do
    Logger.info("board index next-hour")
    :ok = Meeple.next_hour()
    {:noreply, socket}
  end

  def handle_event("toggle_running", %{"running" => "false"}, socket) do
    Logger.info("board index start day")
    :ok = Meeple.start_day()
    {:noreply, socket}
  end

  def handle_event("toggle_running", %{"running" => "true"}, socket) do
    Logger.info("board index stop day")
    :ok = Meeple.stop_day()
    {:noreply, assign(socket, running: false)}
  end

  def handle_info({:error, message}, socket) do
    Logger.warn(message)
    {:noreply, socket |> clear_flash() |> put_flash(:error, message)}
  end

  def handle_info({:field_discovered, %{x: _x, y: _y}}, socket) do
    Logger.info("board index field discovered")
    {:noreply, assign_fields(socket)}
  end

  def handle_info({:grid_updated}, socket) do
    Logger.info("board index grid updated")
    {:noreply, socket |> assign_fields() |> assign(pawns: get_pawns())}
  end

  def handle_info({:plan_updated, _}, socket) do
    Logger.info("board index plan updated")
    update_plan(socket)
    {:noreply, socket}
  end

  def handle_info({:hour_updated, hour: hour}, socket) do
    Logger.info("board index hour updated")
    update_plan(socket)
    {:noreply, socket |> assign_fields() |> assign(hour: hour)}
  end

  def handle_info({:day_started, running: running}, socket) do
    Logger.info("board index day started")
    {:noreply, assign(socket, running: running)}
  end

  def handle_info(ignore, socket) do
    Logger.info("board index ignore #{inspect(ignore)}")
    {:noreply, socket}
  end

  defp prepare_assigns(socket) do
    assign(socket,
      fog_of_war: true,
      fields: get_fields(true),
      pawns: get_pawns(),
      hour: get_hour(),
      running: running?()
    )
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

  defp get_fields(fog_of_war) do
    Board.get_grid(fog_of_war)
  end

  defp get_pawns() do
    Board.get_pawns()
  end

  defp get_hour() do
    Board.get_hour()
  end

  defp running?() do
    Meeple.started?()
  end
end
