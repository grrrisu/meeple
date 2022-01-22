defmodule Meeple.FogOfWarTest do
  use ExUnit.Case, async: true

  alias Meeple.{FogOfWar, Territory}

  setup do
    territory_pid = start_supervised!({Territory, name: :fog_of_war_test_territory})

    fog_of_war_pid =
      start_supervised!(
        {FogOfWar, territory: :fog_of_war_test_territory, name: :fog_of_war_test_fog_of_war}
      )

    :ok = FogOfWar.create("test", fog_of_war_pid)
    :ok = Territory.create("test", territory_pid)
    %{fog_of_war_pid: fog_of_war_pid, territory_pid: territory_pid}
  end

  test "discover", %{fog_of_war_pid: fog_of_war_pid} do
    assert %{} = FogOfWar.field(1, 2, fog_of_war_pid)
    field = FogOfWar.discover(1, 2, fog_of_war_pid)
    assert %{vegetation: :planes} = field
  end
end
