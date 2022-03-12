defmodule Meeple do
  use Sim.Realm, app_module: MeepleRealm

  def create_game(name) do
    send_command({:admin, :create, name: name})
  end

  def clear_plan() do
    send_command({:user, :clear_plan})
  end
end
