defmodule Meeple.Service.Sim do
  @behaviour Sim.CommandHandler

  alias Meeple.{Action, Board}

  def execute(:tick, []) do
    if Board.get_hour() < 11 do
      Meeple.next_hour()
      [{:day_simulated, continued: true}]
    else
      Meeple.stop_day()
      Meeple.clear_plan()
      [{:day_simulated, continued: false}]
    end
  end

  def execute(:execute, action: action) do
    Action.execute(action)
    [{:action_executed, action: action}]
  end
end
