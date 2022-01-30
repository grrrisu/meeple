defmodule Meeple.Pawn do
  @enforce_keys [:id, :x, :y]
  defstruct id: nil, x: nil, y: nil, action_points: 12, planned: 0, executed: 0, health: 5
end
