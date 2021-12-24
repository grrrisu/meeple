defmodule Meeple.Territory do
  use Agent

  alias Meeple.Territory.One

  def start_link(_args) do
    Agent.start_link(&One.create/0, name: __MODULE__)
  end

  def get() do
    Agent.get(__MODULE__, & &1)
  end
end
