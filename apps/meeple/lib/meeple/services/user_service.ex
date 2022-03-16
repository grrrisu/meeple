defmodule Meeple.Service.User do
  use Sim.Commands.SimHelpers, app_module: MeepleRealm

  @behaviour Sim.CommandHandler

  alias Meeple.{Action, Board, Pawn}

  def execute(:add_action, params) do
    if Meeple.started?(),
      do: raise("You can not add an action while the day simulation is running")

    Board.get_planned_actions()
    |> prepare_actions(params)
    |> Enum.map(&Board.add_action(&1))

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

  def prepare_actions(planned, params) do
    planned
    |> set_last_position(params[:pawn])
    |> build_actions(params[:action], params[:x], params[:y])
    |> Enum.reject(&is_nil/1)
  end

  def set_last_position(planned, pawn) do
    if Enum.empty?(planned) do
      pawn
    else
      [action | _] = planned
      %Pawn{pawn | x: action.x, y: action.y}
    end
  end

  def build_actions(pawn, action, x, y) do
    [move_action(pawn, action, x, y), build_action(pawn, action, x, y)]
  end

  def move_action(_pawn, action, _x, _y) when action in [:move, :test], do: nil
  def move_action(%Pawn{x: x, y: y}, _action, x, y), do: nil
  def move_action(pawn, _action, x, y), do: Action.build_move(pawn, x, y)

  def build_action(pawn, :move, x, y), do: Action.build_move(pawn, x, y)
  def build_action(pawn, :discover, x, y), do: Action.build_discover(pawn, x, y)
  def build_action(pawn, :test, x, y), do: %Action{name: :test, pawn: pawn, x: x, y: y, points: 0}
end
