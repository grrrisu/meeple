defmodule MeepleWeb.BoardLive.FieldCard do
  use MeepleWeb, :live_component
  require Logger

  alias Meeple.Territory

  def render(assigns) do
    ~H"""
    <div
      class="bg-gray-50 rounded-lg drop-shadow-lg border border-gray-800 p-4 absolute"
      :class="showFieldCard || 'hidden'"
      style="width: 300px; top: 30px; right: 210px">
      <div class="border border-gray-800">
        <h2>Homebase</h2>
        <div class="" style="height: 392px">
          <div class="my-2 mx-auto">
            <image src="/images/fields/homebase.svg" height="50"/>
          </div>
          <p>
            Description: This is your homebase.
          </p>
          <div>
            Actions available ....
          </div>
        </div>
      </div>
    </div>
    """
  end
end
