defmodule Meeple.Plan do
  use Agent

  def start_link(args \\ []) do
    Agent.start_link(fn -> %{actions: [], action_points: 0} end)
  end
end
