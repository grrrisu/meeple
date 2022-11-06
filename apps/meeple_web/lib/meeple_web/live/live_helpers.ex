defmodule MeepleWeb.LiveHelpers do
  import Phoenix.Component

  def slider_checkbox(assigns) do
    ~H"""
    <label class="relative flex justify-between items-center group px-2 text-md">
      <%= @label %>
      <input name="slider-value" type="checkbox" checked={@checked && "checked"} class="absolute left-1/2 -translate-x-1/2 w-full h-full peer appearance-none rounded-md" />
      <span
        class="w-12 h-5 flex items-center flex-shrink-0 ml-4 p-0 bg-gray-300 rounded-full duration-300 ease-in-out peer-checked:bg-green-400 after:w-5 after:h-5 after:bg-white after:rounded-full after:shadow-md after:duration-300 peer-checked:after:translate-x-7 groupb-hover:after:translate-x-1">
      </span>
    </label>
    """
  end
end
