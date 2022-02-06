defmodule Meeple.GameSessionTest do
  use ExUnit.Case, async: true

  setup do
    start_supervised!({Territory, name: :game_session_test_territory})

    start_supervised!(
      {FogOfWar, territory: :game_session_test_territory, name: :game_session_test_fog_of_war}
    )

    game_session =
      start_supervised!(GameSession,
        name: :game_session_test,
        fog_of_war: :game_session_test_fog_of_war
      )

    %{game_session: game_session}
  end
end
