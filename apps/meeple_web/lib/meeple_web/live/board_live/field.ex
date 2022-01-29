defmodule MeepleWeb.BoardLive.Field do
  use Phoenix.Component

  require Logger

  alias Phoenix.LiveView.JS

  import MeepleWeb.BoardLive.FieldHelper

  def fade_in(x, y, target) do
    JS.push("show", value: %{x: x, y: y}, target: target)
    |> JS.show(
      transition: {"ease-out duration-500", "opacity-25", "opacity-100"},
      to: "#field-card"
    )
  end

  def field_title(field) do
    vegetation = field[:vegetation]
    flora = field[:flora] && Enum.join(field[:flora], ": ")
    fauna = (field[:herbivore] || field[:predator] || []) |> Enum.join(": ")
    "v: #{vegetation}\nf: #{flora}\na: #{fauna}"
  end

  def field(%{field: {x, y, field}} = assigns) do
    assigns = assign(assigns, x: x, y: y, field: field)

    ~H"""
    <div
      id={"field-#{@x}-#{@y}"}
      class="field text-[0.5rem] relative"
      @click="showFieldCard = true"
      phx-click={fade_in(@x, @y, @target)}
      title={field_title(@field)}>
        <.pawns pawns={@field[:pawns]} />
        <.background field={@field} />
    </div>
    """
  end

  def background(%{field: %{building: _building}} = assigns) do
    assigns |> assign(image: "homebase.svg") |> background_image()
  end

  def background(%{field: %{vegetation: vegetation}} = assigns) do
    assigns |> assign(image: vegetation_image(vegetation)) |> background_image()
  end

  def background(%{field: %{}} = assigns), do: empty(assigns)

  def background_image(assigns) do
    ~H"""
      <image src={"/images/fields/#{@image}"} class="w-full"/>
    """
  end

  def pawns(%{pawns: pawns} = assigns) when is_list(pawns) do
    ~H"""
    <div class="absolute m-3" style="width: 25px; height: 25px">
      <img src="/images/ui/human_token.svg" class="w-full"/>
    </div>
    """
  end

  def pawns(assigns), do: empty(assigns)

  def empty(assigns) do
    ~H"""
    """
  end
end
