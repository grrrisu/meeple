defmodule Meeple.Plan do
  use Agent

  @type points :: integer
  @type done :: integer
  @type name :: atom
  @type payload :: list
  @type pawn :: integer
  @type action :: %{name: name, pawn: pawn, points: points, done: done, payload: payload}

  def start_link(args \\ []) do
    Agent.start_link(fn -> %{actions: [], total_points: 0} end, name: args[:name] || __MODULE__)
  end

  def get(pid \\ __MODULE__) do
    Agent.get(pid, fn state -> state end)
  end

  def add_action(action, pid \\ __MODULE__) do
    Agent.get_and_update(pid, fn state ->
      actions = [action | state.actions]
      total_points = action.points + state.total_points
      {total_points, %{actions: actions, total_points: total_points}}
    end)
  end

  def tick(pid \\ __MODULE__) do
    Agent.update(pid, fn %{actions: [action | rest]} = state ->
      action = %{action | done: action.done + 1}

      case action.done == action.points do
        true ->
          Meeple.FogOfWar.discover(action.params.x, action.params.y)
          %{state | actions: rest}

        false ->
          %{state | actions: [action | rest]}
      end
    end)
  end
end
