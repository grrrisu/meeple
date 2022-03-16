defmodule Meeple.Plan do
  use Agent

  require Logger

  alias Meeple.Action

  @spec start_link(nil | maybe_improper_list | map) :: {:error, any} | {:ok, pid}
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

  def get_planned(pid \\ __MODULE__) do
    Agent.get(pid, fn %{planned: planned} -> :queue.to_list(planned) end)
  end

  def clear(pid \\ __MODULE__) do
    Agent.cast(pid, fn _ -> initial_state() end)
  end

  def add_action(action, pid \\ __MODULE__) do
    Agent.update(pid, fn state -> add_to_planned(state, action) end)
  end

  def add_to_planned(state, action) do
    actions = :queue.in(action, state.planned)
    total_points = action.points + state.total_points
    %{state | planned: actions, total_points: total_points}
  end

  @spec inc_action(atom | pid | {atom, any} | {:via, atom, any}) ::
          :empty | :increased | {:executable, %Action{}}
  def inc_action(pid \\ __MODULE__) do
    Agent.get_and_update(pid, fn state ->
      state
      |> current_planned_action()
      |> inc_done()
      |> executable_action()
    end)
  end

  def current_planned_action(state), do: {:queue.out(state.planned), state}

  def inc_done({{{:value, action}, planned}, state}) do
    {%Action{action | done: action.done + 1}, planned, state}
  end

  def inc_done({{:empty, planned}, state}), do: {:empty, planned, state}

  def executable_action({%Action{points: points, done: points} = action, planned, state}) do
    {{:executable, action}, %{state | planned: planned, done: :queue.in(action, state.done)}}
  end

  def executable_action({%Action{} = action, planned, state}) do
    {:increased, %{state | planned: :queue.in_r(action, planned)}}
  end

  def executable_action({:empty, _planned, state}), do: {:empty, state}
end
