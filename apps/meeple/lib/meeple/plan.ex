defmodule Meeple.Plan do
  use Agent

  @type points :: integer
  @type done :: integer
  @type name :: atom
  @type params :: map
  @type pawn :: integer
  @type action :: %{name: name, pawn: pawn, points: points, done: done, params: params}

  def start_link(args \\ []) do
    Agent.start_link(fn -> %{actions: [], total_points: 0} end, name: args[:name] || __MODULE__)
  end

  def get(pid \\ __MODULE__) do
    Agent.get(pid, fn state -> state end)
  end

  @spec add_action(action, atom | pid | {atom, any} | {:via, atom, any}) :: any
  def add_action(action, pid \\ __MODULE__) do
    Agent.get_and_update(pid, fn state ->
      actions = [action | state.actions]
      total_points = action.points + state.total_points
      # temp
      broadcast_plan_updated()
      {total_points, %{actions: actions, total_points: total_points}}
    end)
  end

  def tick(pid \\ __MODULE__) do
    Agent.update(pid, &inc_actions(&1))
  end

  defp inc_actions(%{actions: [%{params: %{x: x, y: y}} = action | rest]} = state) do
    action = %{action | done: action.done + 1}

    case action.done == action.points do
      true ->
        # events:
        # plan: [plan_updated, field_discovered, yellow_karma_received]
        # fog_of_war: [fog_of_war_updated], xp_pool: [xp_pool_updated]
        Meeple.FogOfWar.discover(x, y)
        # temp
        broadcast_field_discovered(x, y)
        broadcast_plan_updated()

        %{state | actions: rest}

      false ->
        %{state | actions: [action | rest]}
    end
  end

  defp inc_actions(state), do: state

  defp broadcast_field_discovered(x, y) do
    broadcast_event({:field_discovered, %{x: x, y: y}})
  end

  defp broadcast_plan_updated do
    broadcast_event({:plan_updated})
  end

  @spec broadcast_event(any) :: :ok | {:error, any}
  defp broadcast_event(event) do
    :ok = Phoenix.PubSub.broadcast(Meeple.PubSub, "GameSession", event)
  end
end
