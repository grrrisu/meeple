defmodule Meeple.Plan do
  use Agent

  require Logger

  alias Meeple.{Action, Pawn}

  def start_link(args \\ []) do
    Agent.start_link(&initial_state/0, name: args[:name] || __MODULE__)
  end

  defp initial_state() do
    %{planned: :queue.new(), done: :queue.new(), total_points: 0}
  end

  def get(pid \\ __MODULE__) do
    Agent.get(pid, fn %{planned: planned, done: done} = state ->
      %{
        actions: :queue.to_list(done) ++ :queue.to_list(planned),
        total_points: state.total_points
      }
    end)
  end

  def clear(pid \\ __MODULE__) do
    Agent.cast(pid, fn _ ->
      broadcast_plan_updated()
      initial_state()
    end)
  end

  def add_action(%Action{} = action, pid \\ __MODULE__) do
    Agent.update(pid, fn state ->
      position = last_position(state, action)

      state =
        state
        |> add_to_planned(move_action(action, position))
        |> add_to_planned(action)

      # temp
      broadcast_plan_updated()
      state
    end)
  end

  def last_position(state, action) do
    case :queue.is_empty(state.planned) do
      true ->
        # get_pawn with id and return {pawn.x, pawn.y}
        {action.pawn.x, action.pawn.y}

      false ->
        action = :queue.get_r(state.planned)
        {action.x, action.y}
    end
  end

  def move_action(%Action{name: action}, _position) when action in [:test, :move], do: nil
  def move_action(%{x: x, y: y}, {x, y}), do: nil
  def move_action(action, position), do: Action.build_move(action, position)

  # @spec add_to_planned(map, action) :: map
  def add_to_planned(state, nil), do: state

  def add_to_planned(state, action) do
    actions = :queue.in(action, state.planned)
    total_points = action.points + state.total_points
    %{state | planned: actions, total_points: total_points}
  end

  def tick(pid \\ __MODULE__) do
    Agent.cast(pid, fn %{planned: actions} = state ->
      case :queue.is_empty(actions) do
        false -> inc_action(state)
        true -> state
      end
    end)
  end

  def inc_action(%{planned: planned, done: done} = state) do
    {{:value, action}, planned} = :queue.out(planned)
    action = %Action{action | done: action.done + 1}

    case action.done == action.points do
      true ->
        Action.execute(action)
        broadcast_plan_updated()
        %{state | planned: planned, done: :queue.in(action, done)}

      false ->
        # events:
        # plan: [plan_updated, execution_finished]
        broadcast_plan_updated()
        %{state | planned: :queue.in_r(action, planned)}
    end
  end

  defp broadcast_plan_updated do
    broadcast_event({:plan_updated})
  end

  @spec broadcast_event(any) :: :ok | {:error, any}
  defp broadcast_event(event) do
    :ok = Phoenix.PubSub.broadcast(Meeple.PubSub, "GameSession", event)
  end
end
