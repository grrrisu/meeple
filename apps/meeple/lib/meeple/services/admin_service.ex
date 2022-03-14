defmodule Meeple.Service.Admin do
  @behaviour Sim.CommandHandler

  alias Meeple.Board

  def execute(:create, name: name) do
    :ok = Board.create(name)
    [{:game_created, name: name}]
  end

  def execute(:clear_plan, []) do
    Board.clear_plan()
    [{:plan_updated, :cleared}]
  end

  def execute(:next_hour, []) do
    [{:hour_updated, hour: Board.next_hour()}] ++ inc_action()
  end

  defp inc_action() do
    case Board.inc_action() do
      :empty ->
        []

      :increased ->
        [{:plan_updated, :action_increased}]

      {:executable, action} ->
        :ok = Meeple.execute_action(action)
        [{:plan_updated, :action_prepared}]
    end
  end
end
