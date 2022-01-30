defmodule Meeple.GameSession do
  use GenServer

  alias Meeple.{FogOfWar, Plan}

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: opts[:name] || __MODULE__)
  end

  @impl true
  def init(opts) do
    state = %{fog_of_war: opts[:fog_of_war] || FogOfWar, plan: opts[:plan] || Plan}
    {:ok, state}
  end
end
