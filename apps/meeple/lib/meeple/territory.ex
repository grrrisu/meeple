defmodule Meeple.Territory do
  use Agent

  alias Sim.Grid

  def start_link(_args) do
    Agent.start_link(&create/0, name: __MODULE__)
  end

  def get() do
    Agent.get(__MODULE__, & &1)
  end

  def create(), do: Grid.create(15, 7, &field/2)

  defp field(_x, 0), do: :high_mountain
  defp field(7, 1), do: :headquarter
  defp field(_x, _y), do: nil
end
