defmodule MeepleWeb.BoardLive.Map do
  use MeepleWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="map" class="board-map map" style="grid-template-columns: repeat(10, 1fr)">
      <div class="field bg-brown-50"></div>
      <div class="field bg-almond-50"></div>
      <div class="field bg-copperfield-50"></div>
      <div class="field bg-olive-50"></div>
      <div class="field bg-grass-50"></div>
      <div class="field bg-yellowish-50"></div>
      <div class="field bg-steelblue-50"></div>
      <div class="field bg-blood-50"></div>
      <div class="field bg-marine-50"></div>
      <div class="field bg-forest-50"></div>

      <div class="field bg-brown-100"></div>
      <div class="field bg-almond-100"></div>
      <div class="field bg-copperfield-100"></div>
      <div class="field bg-olive-100"></div>
      <div class="field bg-grass-100"></div>
      <div class="field bg-yellowish-100"></div>
      <div class="field bg-steelblue-100"></div>
      <div class="field bg-blood-100"></div>
      <div class="field bg-marine-100"></div>
      <div class="field bg-forest-100"></div>

      <div class="field bg-brown-200"></div>
      <div class="field bg-almond-200"></div>
      <div class="field bg-copperfield-200"></div>
      <div class="field bg-olive-200"></div>
      <div class="field bg-grass-200"></div>
      <div class="field bg-yellowish-200"></div>
      <div class="field bg-steelblue-200"></div>
      <div class="field bg-blood-200"></div>
      <div class="field bg-marine-200"></div>
      <div class="field bg-forest-200"></div>

      <div class="field bg-brown-300"></div>
      <div class="field bg-almond-300"></div>
      <div class="field bg-copperfield-300"></div>
      <div class="field bg-olive-300"></div>
      <div class="field bg-grass-300"></div>
      <div class="field bg-yellowish-300"></div>
      <div class="field bg-steelblue-300"></div>
      <div class="field bg-blood-300"></div>
      <div class="field bg-marine-300"></div>
      <div class="field bg-forest-300"></div>

      <div class="field bg-brown-400"></div>
      <div class="field bg-almond-400"></div>
      <div class="field bg-copperfield-400"></div>
      <div class="field bg-olive-400"></div>
      <div class="field bg-grass-400"></div>
      <div class="field bg-yellowish-400"></div>
      <div class="field bg-steelblue-400"></div>
      <div class="field bg-blood-400"></div>
      <div class="field bg-marine-400"></div>
      <div class="field bg-forest-400"></div>

      <div class="field bg-brown-500"></div>
      <div class="field bg-almond-500"></div>
      <div class="field bg-copperfield-500"></div>
      <div class="field bg-olive-500"></div>
      <div class="field bg-grass-500"></div>
      <div class="field bg-yellowish-500"></div>
      <div class="field bg-steelblue-500"></div>
      <div class="field bg-blood-500"></div>
      <div class="field bg-marine-500"></div>
      <div class="field bg-forest-500"></div>

      <div class="field bg-brown-600"></div>
      <div class="field bg-almond-600"></div>
      <div class="field bg-copperfield-600"></div>
      <div class="field bg-olive-600"></div>
      <div class="field bg-grass-600"></div>
      <div class="field bg-yellowish-600"></div>
      <div class="field bg-steelblue-600"></div>
      <div class="field bg-blood-600"></div>
      <div class="field bg-marine-600"></div>
      <div class="field bg-forest-600"></div>

      <div class="field bg-brown-700"></div>
      <div class="field bg-almond-700"></div>
      <div class="field bg-copperfield-700"></div>
      <div class="field bg-olive-700"></div>
      <div class="field bg-grass-700"></div>
      <div class="field bg-yellowish-700"></div>
      <div class="field bg-steelblue-700"></div>
      <div class="field bg-blood-700"></div>
      <div class="field bg-marine-700"></div>
      <div class="field bg-forest-700"></div>

      <div class="field bg-brown-800"></div>
      <div class="field bg-almond-800"></div>
      <div class="field bg-copperfield-800"></div>
      <div class="field bg-olive-800"></div>
      <div class="field bg-grass-800"></div>
      <div class="field bg-yellowish-800"></div>
      <div class="field bg-steelblue-800"></div>
      <div class="field bg-blood-800"></div>
      <div class="field bg-marine-800"></div>
      <div class="field bg-forest-800"></div>

      <div class="field bg-brown-900"></div>
      <div class="field bg-almond-900"></div>
      <div class="field bg-copperfield-900"></div>
      <div class="field bg-olive-900"></div>
      <div class="field bg-grass-900"></div>
      <div class="field bg-yellowish-900"></div>
      <div class="field bg-steelblue-900"></div>
      <div class="field bg-blood-900"></div>
      <div class="field bg-marine-900"></div>
      <div class="field bg-forest-900"></div>
    </div>
    """
  end
end