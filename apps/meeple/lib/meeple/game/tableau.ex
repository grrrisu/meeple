defmodule Meeple.Tableau do
  use Agent

  alias Meeple.Territory.One
  alias Meeple.Territory.Test, as: TestTerritory

  def start_link(args \\ []) do
    Agent.start_link(&initial_state/0, name: args[:name] || __MODULE__)
  end

  defp initial_state() do
    %{
      weather: "sunny",
      headquarter: nil,
      pawns: [],
      season: "spring",
      day: 1,
      hour: 0,
      inventory: [],
      xp_pool: %{}
    }
  end

  def create(name, pid \\ __MODULE__) do
    Agent.get_and_update(pid, fn state ->
      {:ok,
       %{
         state
         | headquarter: set_headquarter(name),
           pawns: set_pawns(name),
           inventory: set_inventory(name),
           xp_pool: set_xp_pool(name)
       }}
    end)
  end

  def pawns(pid \\ __MODULE__) do
    Agent.get(pid, fn %{pawns: pawns} -> pawns end)
  end

  defp set_headquarter("one"), do: One.headquarter()
  defp set_headquarter("test"), do: TestTerritory.headquarter()

  defp set_pawns("one"), do: One.pawns()
  defp set_pawns("test"), do: TestTerritory.pawns()

  defp set_inventory("one"), do: One.inventory()
  defp set_inventory("test"), do: TestTerritory.inventory()

  defp set_xp_pool("one"), do: One.xp_pool()
  defp set_xp_pool("test"), do: TestTerritory.xp_pool()
end
