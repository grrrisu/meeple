defmodule Meeple.Action do
  @enforce_keys [:name, :pawn, :x, :y, :points]
  defstruct name: nil, pawn: nil, x: nil, y: nil, points: 0, done: 0, params: []

  require Logger

  alias Meeple.{Action, Board, Pawn}

  @move_costs 3
  def build_move(%Action{pawn: %Pawn{} = pawn, x: x, y: y}) do
    # points = (abs(pawn.x - x) + abs(pawn.y - y)) / @move_costs # wheater and pawn.skills and ...
    points = ((abs(pawn.x - x) + abs(pawn.y - y)) / @move_costs) |> Float.ceil() |> trunc()
    %Action{name: :move, pawn: pawn, x: x, y: y, points: points}
  end

  def execute(%Action{name: :move, pawn: pawn, x: x, y: y}) do
    Logger.info("move action finished")

    pawn = Board.get_pawn(pawn.id)
    :ok = Board.move_pawn(pawn, x, y)

    # update field information
    field = Board.get_field(x, y, true)

    if field.visability > 0 do
      :ok = Board.discover_field(x, y)
    end

    broadcast_grid_changed()
    # may trigger a danger event
  end

  def execute(%Action{name: :discover, x: x, y: y}) do
    Logger.info("discover action finished")
    # events:
    # plan: [field_discovered, yellow_karma_received, execution_stopped]
    # fog_of_war: [fog_of_war_updated], xp_pool: [xp_pool_updated], game_session: [clock_stopped]
    :ok = Board.discover_field(x, y)
    # temp
    broadcast_field_discovered(x, y)
  end

  defp broadcast_field_discovered(x, y) do
    broadcast_event({:field_discovered, %{x: x, y: y}})
  end

  defp broadcast_grid_changed() do
    broadcast_event({:grid_changed})
  end

  defp broadcast_event(event) do
    :ok = Phoenix.PubSub.broadcast(Meeple.PubSub, "GameSession", event)
  end
end
