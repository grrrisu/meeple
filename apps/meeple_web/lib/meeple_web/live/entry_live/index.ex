defmodule MeepleWeb.EntryLive.Index do
  use MeepleWeb, :live_view

  alias Meeple.Board

  require Logger

  def mount(_params, _session, socket) do
    if connected?(socket), do: subscribe()
    {:ok, assign(socket, map_exists: Board.map_exists?())}
  end

  def handle_params(params, session, socket) do
    {:noreply, handle_action(socket.assigns.live_action, params, session, socket)}
  end

  def handle_action(:index, _params, _session, socket) do
    socket
  end

  def handle_action(:create, %{"territory" => territory}, _session, socket) do
    create_territory(territory)

    socket
    |> put_flash(:info, "creating board #{territory} ...")
  end

  def render(assigns) do
    ~H"""
    <h1>Meeple</h1>
    <p>A tactical game inspired by board games.</p>

    <p>
      <%= live_redirect "Rules", to: Routes.rules_index_path(@socket, :index) %>
    </p>

    <%= if @map_exists do %>
      <p>
        <%= live_redirect "Go to current board", to: Routes.board_index_path(@socket, :index), class: "btn btn-action" %>
      </p>
    <% end %>
    <p><%= live_patch "Create Board One", to: Routes.entry_index_path(@socket, :create, :one), class: "btn btn-action"  %></p>
    <p><%= live_patch "Create Board Test", to: Routes.entry_index_path(@socket, :create, :test), class: "btn btn-action"  %></p>

    <%= if Mix.env() == :dev do %>
      <h3>Development</h3>
      <p><a href="/dashboard">Dashboard</a></p>
      <p><a href="/dev/colors">Color Palette</a></p>
    <% end %>
    """
  end

  def handle_info({:game_created, name: name}, socket) do
    Logger.info("game #{name} created")

    {:noreply,
     socket
     |> put_flash(:info, "board #{name} created")
     |> push_redirect(to: "/board")}
  end

  def handle_info(ignore, socket) do
    Logger.info("entry live ignore #{inspect(ignore)}")
    {:noreply, socket}
  end

  defp create_territory(name) do
    Meeple.create_game(name)
  end

  defp subscribe() do
    Phoenix.PubSub.subscribe(Meeple.PubSub, "GameSession")
  end
end
