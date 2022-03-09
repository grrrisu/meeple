defmodule Meeple.Service.Sim do
  @behaviour Sim.CommandHandler

  alias Sim.SimulationLoop
  alias Meeple.{Tableau, Plan}

  def execute(:start_day, delay: _delay) do
    SimulationLoop.start(1_000, fn ->
      if next_hour() < 11 do
        :ok
      else
        Plan.clear()
        :stop
      end
    end)

    [{:sim, started: true}]
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

  def execute(:plan, :action_ready, action: action) do
    Action.execute(action)
  end

  defp next_hour() do
    Plan.tick()
    Tableau.inc_hour()
  end
end
