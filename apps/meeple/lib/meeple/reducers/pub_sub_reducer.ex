defmodule Meeple.PubSubReducer do
  def reduce(events) do
    Enum.map(events, fn event ->
      Phoenix.PubSub.broadcast(Meeple.PubSub, "GameSession", event)
    end)
  end
end
