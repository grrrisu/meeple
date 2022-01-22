defmodule MeepleWeb.BoardLive.Plan do
  use MeepleWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="plan" class="board-pawns">
      <div class="border h-20 w-20">Step 1</div>
      <div class="border h-20 w-20">Step 2</div>
      <div class="border h-20 w-20">Step 3</div>
      <div class="border h-20 w-20">Step 4</div>
    </div>
    """
  end
end
