defmodule Meeple.Service.Admin do
  @behaviour Sim.CommandHandler

  alias Meeple.Board

  def execute(:create, name: name) do
    :ok = Board.create(name)
    [{:game_created, name: name}]
  end

  def execute(:clear_plan, []) do
    Board.clear_plan()
    [{:plan_updated, :cleared}]
  end

  def execute(:next_hour, []) do
    hour = Board.next_hour()
    [{:hour_updated, hour: hour}]
  end
end
