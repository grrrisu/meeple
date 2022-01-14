defmodule Meeple.BoardSupervisor do
  use Supervisor

  alias Meeple.{FogOfWar, Territory}

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(:ok) do
    children = [
      Territory,
      FogOfWar
    ]

    Supervisor.init(children, strategy: :rest_for_one)
  end
end
