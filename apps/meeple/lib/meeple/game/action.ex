defmodule Meeple.Action do
  @enforce_keys [:name, :pawn, :x, :y, :points]
  defstruct name: nil, pawn: nil, x: nil, y: nil, points: 0, done: 0, params: []
end
