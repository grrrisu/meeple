defmodule Meeple.GameSession do
  use GenServer

  require Logger

  alias Meeple.{Board, FogOfWar, Plan}

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name] || __MODULE__)
  end

  @impl true
  def init(opts) do
    state = %{fog_of_war: opts[:fog_of_war] || FogOfWar, plan: opts[:plan] || Plan}
    {:ok, state, {:continue, :subscribe}}
  end

  @impl true
  def handle_continue(:subscribe, state) do
    subscribe()
    {:noreply, state}
  end

  @impl true
  def handle_info({:action_executed, action: _action}, state) do
    Logger.info("action executed")
    Board.update_fog_of_war()
    broadcast_grid_updated()
    {:noreply, state}
  end

  @impl true
  def handle_info(_ignore, state) do
    Logger.info("ignore")
    {:noreply, state}
  end

  defp subscribe() do
    :ok = Phoenix.PubSub.subscribe(Meeple.PubSub, "GameSession")
  end

  defp broadcast_grid_updated() do
    broadcast_event({:grid_updated})
  end

  defp broadcast_event(event) do
    :ok = Phoenix.PubSub.broadcast(Meeple.PubSub, "GameSession", event)
  end
end
