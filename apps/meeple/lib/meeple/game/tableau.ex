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
      day: 0,
      hour: 0,
      inventory: [],
      xp_pool: %{}
    }
  end

  def create(name, pid \\ __MODULE__) do
    Agent.get_and_update(pid, fn _ ->
      state =
        Map.merge(initial_state(), %{
          headquarter: set_headquarter(name),
          pawns: set_pawns(name),
          inventory: set_inventory(name),
          xp_pool: set_xp_pool(name)
        })

      {:ok, state}
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

  def hour(pid \\ __MODULE__) do
    Agent.get(pid, & &1.hour)
  end

  def inc_hour(pid \\ __MODULE__) do
    Agent.update(pid, fn state ->
      broadcast_hour_updated()

      hour =
        case state.hour do
          11 -> 0
          hour -> hour + 1
        end

      %{state | hour: hour}
    end)
  end

  defp broadcast_hour_updated do
    broadcast_event({:hour_updated})
  end

  @spec broadcast_event(any) :: :ok | {:error, any}
  defp broadcast_event(event) do
    :ok = Phoenix.PubSub.broadcast(Meeple.PubSub, "GameSession", event)
  end
end
