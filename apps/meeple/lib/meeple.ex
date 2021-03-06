defmodule Meeple do
  use Sim.Realm, app_module: MeepleRealm

  def create_game(name) do
    send_command({:admin, :create, name: name})
  end

  def next_hour() do
    send_command({:admin, :next_hour})
  end

  def clear_plan() do
    send_command({:admin, :clear_plan})
  end

  def add_action(pawn, action, params) do
    send_command({:user, :add_action, pawn: pawn, action: action, x: params[:x], y: params[:y]})
  end

  def start_day() do
    send_command({:user, :start_day})
  end

  def stop_day() do
    send_command({:user, :stop_day})
  end

  def tick() do
    send_command({:sim, :tick})
  end

  def execute_action(action) do
    send_command({:sim, :execute, action: action})
  end
end
