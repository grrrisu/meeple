defmodule Meeple.Plan do
  use Agent

  require Logger

  alias Meeple.{Action, Pawn}

  @type points :: integer
  @type done :: integer
  @type name :: atom
  @type params :: map
  @type pawn :: integer
  @type action :: %{
          name: name,
          pawn: pawn,
          x: integer,
          y: integer,
          points: points,
          done: done,
          params: params
        }

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

  @spec add_action(action, atom | pid | {atom, any} | {:via, atom, any}) :: any
  def add_action(%Action{} = action, pid \\ __MODULE__) do
    Agent.update(pid, fn state ->
      state = may_add_move_action(state, action)
      state = add_to_planned(state, action)
      # temp
      broadcast_plan_updated()
      state
    end)
  end

  def may_add_move_action(state, %Action{name: :move}), do: state
  def may_add_move_action(state, %{pawn: %Pawn{x: x, y: y}, x: x, y: y}), do: state
  def may_add_move_action(state, action), do: add_to_planned(state, move_action(action))

  # @spec add_to_planned(map, action) :: map
  def add_to_planned(state, action) do
    actions = :queue.in(action, state.planned)
    total_points = action.points + state.total_points
    %{state | planned: actions, total_points: total_points}
  end

  @move_costs 3
  def move_action(%Action{pawn: %Pawn{} = pawn, x: x, y: y}) do
    # points = (abs(pawn.x - x) + abs(pawn.y - y)) / @move_costs # wheater and pawn.skills and ...
    points = ((abs(pawn.x - x) + abs(pawn.y - y)) / @move_costs) |> Float.ceil() |> trunc()
    %Action{name: :move, pawn: pawn, x: x, y: y, points: points}
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
        action_finished(action)
        broadcast_plan_updated()
        %{state | planned: planned, done: :queue.in(action, done)}

      false ->
        # events:
        # plan: [plan_updated, execution_finished]
        broadcast_plan_updated()
        %{state | planned: :queue.in_r(action, planned)}
    end
  end

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

  # --- actions ---

  def action_finished(%Action{name: :move, pawn: _pawn, x: _x, y: _y}) do
    Logger.info("move action finished")
    # events:
    # plan: [pawn_moved, field_discovered/updated, may_trigger_danger_event]
    # fog_of_war: [fog_of_war_updated], ...
    # Meeple.Territory.move_pawn(from: {pawn.x, pawn.y}, to: x, y)
    # Meeple.Pawn.move(pawn, x, y)
    # Meeple.FogOfWar.discover(x, y) # update fog_of_war by passing by expect it is has not yet been discoverd
    # broadcast_field_discovered(x, y)
  end

  def action_finished(%Action{name: :discover, x: x, y: y}) do
    Logger.info("discover action finished")
    # events:
    # plan: [field_discovered, yellow_karma_received, execution_stopped]
    # fog_of_war: [fog_of_war_updated], xp_pool: [xp_pool_updated], game_session: [clock_stopped]
    Meeple.FogOfWar.discover(x, y)
    # temp
    broadcast_field_discovered(x, y)
  end

  # go to field and see what there, interupt clock
  def action_finished(%{name: :see, x: _x, y: _y}) do
  end
end
