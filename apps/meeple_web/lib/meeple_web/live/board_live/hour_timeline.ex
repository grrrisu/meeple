defmodule MeepleWeb.BoardLive.HourTimeline do
  use MeepleWeb, :component

  def map(assigns) do
    bottom =
      cond do
        assigns.hour == 0 || assigns.hour == 11 -> -35
        assigns.hour == 1 || assigns.hour == 10 -> -15
        assigns.hour == 2 || assigns.hour == 9 -> 0
        assigns.hour == 3 || assigns.hour == 8 -> 5
        assigns.hour == 4 || assigns.hour == 7 -> 15
        assigns.hour == 5 || assigns.hour == 6 -> 25
        true -> 0
      end

    assigns = assign(assigns, bottom: bottom)

    ~H"""
    <div id="map-hour-timeline" class="w-full h-4/5 overflow-hidden relative grid" style="grid-template-columns: repeat(12, 1fr)">
      <div class={"absolute #{sun_transistion(@hour)}"} style={"bottom: #{@bottom}%; left: #{@hour/12 * 100}%"}>
        <img style="margin-left: 8px; width: 30px" src="/images/ui/sun_symbol.svg" />
      </div>
      <%= for i <- 0..11 do %>
        <div class="mx-0.5 py-2 text-center text-steelblue-500 bg-steelblue-300 rounded-xl shadow-inner">
          <span class={"py-3 transition-opacity duration-[1000ms] #{hour_digit(@hour, i)}"}><%= i + 1 %></span>
        </div>
      <% end %>
    </div>
    """
  end

  defp hour_digit(hour, digit) do
    if digit == hour, do: "opacity-0", else: "opacity-100"
  end

  defp sun_transistion(hour) do
    if hour > 0, do: "transition-position duration-[1000ms]"
  end

  def plan(assigns) do
    top = if assigns.hour == 0 || assigns.hour == 11, do: 12, else: 0
    assigns = assign(assigns, top: top)

    ~H"""
    <div id="plan-hour-timeline" class="relative w-full mx-8">
      <div class={"absolute overflow-hidden #{sun_transistion(@hour)}"} style={"width: 25px; height: 25px; top: 10px; left: #{@hour/12 * 100}%"}>
        <img class="absolute #{sun_transistion(@hour})}" style={"top: #{@top}px"} src={"/images/ui/sun_symbol.svg"} />
      </div>
    </div>
    """
  end
end
