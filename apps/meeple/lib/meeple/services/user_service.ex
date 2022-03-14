defmodule Meeple.Service.User do
  use Sim.Commands.SimHelpers, app_module: MeepleRealm

  @behaviour Sim.CommandHandler

  alias Meeple.Board

  def execute(:add_action, params) do
    if Meeple.started?(),
      do: raise("You can not add an action while the day simulation is running")

    Board.add_action(params[:pawn], params[:action], x: params[:x], y: params[:y])
    [{:plan_updated, :action_added}]
  end

  def execute(:start_day, []) do
    start_simulation_loop(1_000, &Meeple.tick/0)
    [{:day_started, running: true}]
  end

  def execute(:stop_day, []) do
    stop_simulation_loop()
    [{:day_started, running: false}]
  end
end
