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
end
