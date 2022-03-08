defmodule Meeple do
  alias Sim.Realm
  use Realm, app_module: __MODULE__

  def create(name) do
    send_command({:create, name: name})
  end
end
