defmodule ThundermoonWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  def slider_checkbox(assigns) do
    ~H"""
    <label class="relative flex justify-between items-center group p-2 text-xl">
      Admin View
      <input name="slider-value" type="checkbox" class="absolute left-1/2 -translate-x-1/2 w-full h-full peer appearance-none rounded-md" />
      <span
        class="w-16 h-10 flex items-center flex-shrink-0 ml-4 p-1 bg-gray-300 rounded-full duration-300 ease-in-out peer-checked:bg-green-400 after:w-8 after:h-8 after:bg-white after:rounded-full after:shadow-md after:duration-300 peer-checked:after:translate-x-6 groupb-hover:after:translate-x-1">
      </span>
    </label>
    """
  end

end
