defmodule Meeple.Service.Sim do
  @behaviour Sim.CommandHandler

  alias Meeple.Board

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

  # def execute(:tick) do
  #   action = Plan.next_action()
  #   events = [{:plan, :updated}]

  #   if action.done == action.points do
  #     Plan.conclude_action(action)
  #     events = [{:plan, :action_ready, action: action} | events]
  #   else
  #     Plan.update_points(action)
  #   end

  #   events
  # end

  # def execute(:plan, :action_ready, action: action) do
  #   Action.execute(action)
  # end
end
