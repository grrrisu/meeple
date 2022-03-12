defmodule Meeple.PubSubReducer do
  require Logger

  def reduce(events) do
    Enum.map(events, fn event ->
      Logger.info("publish event: #{inspect(event)}")
      Phoenix.PubSub.broadcast(Meeple.PubSub, "GameSession", event)
    end)
  end
end
