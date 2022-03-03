defmodule MeepleWeb.RulesLive.Index do
  use MeepleWeb, :live_view

  import MeepleWeb.BoardLive.FieldHelper

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Meeple Rules</h1>
    <h2>Vegetation</h2>
    <p>

    </p>
    <div class="grid grid-cols-5">
      <div class="font-bold">Type</div>
      <div class="font-bold mx-2">Description</div>
      <div class="font-bold mx-2">Flora</div>
      <div class="font-bold mx-2">Fauna</div>
      <div class="font-bold mx-2">Dangers</div>
    </div>
    <div>
      <.field title="Terra Incognita" type={:unknown}>
        <:flora>Unknown</:flora>
        <:fauna>Unknown</:fauna>
        <:danger>Unknown</:danger>
      </.field>
      <.field title="High Mountains" type={:high_mountains}>
        <:flora>Herbs</:flora>
        <:fauna>Goats / Lynx</:fauna>
        <:danger>Avalanches</:danger>
      </.field>
      <.field title="Mountains" type={:mountains}>
        <:flora>Herbs</:flora>
        <:fauna>Goats / Lynx / (Wolf / Bear / Cave Lion)</:fauna>
        <:danger>Rockfall</:danger>
      </.field>
      <.field title="Hills" type={:hills}>
        <:flora>Apples</:flora>
        <:fauna>Partridge / Fox</:fauna>
        <:danger>Thorn scrubs</:danger>
      </.field>
      <.field title="Woods" type={:woods}>
        <:flora>Berries Mushrooms</:flora>
        <:fauna>Fox Rabbit Boar Wolf Deer</:fauna>
        <:danger>Get Lost</:danger>
      </.field>
      <.field title="Planes" type={:planes}>
        <:flora>Roots / (Berry)</:flora>
        <:fauna>Aurochs / Wolf / Cave Lion</:fauna>
        <:danger>Snakes</:danger>
      </.field>
      <.field title="Swamps" type={:swamps}>
        <:flora>Mushrooms</:flora>
        <:fauna>Partridge / Fox / Boar</:fauna>
        <:danger>Swamp holes/ Snakes</:danger>
      </.field>
      <.field title="Lake" type={:lake}>
        <:flora>Apples</:flora>
        <:fauna>Fish/ Boar / Bear / Wolf</:fauna>
        <:danger>Snakes</:danger>
      </.field>
    </div>
    <p class="mb-5">
      <a href="/">&lt; Back</a>
    </p>

    <h3>Flora</h3>
    <h3>Fauna</h3>
    <h2>Weather</h2>
    """
  end

  def field(assigns) do
    ~H"""
    <div class="my-4">
      <h4><%= @title %></h4>
      <div class="grid grid-cols-5 h-40">
        <div class="w-40"><img src={"/images/fields/#{vegetation_image(@type)}"}></div>
        <div class="text-sm italic">
          <%= description(@type) %>
        </div>
        <div class="mx-2"><%= render_slot(@flora) %></div>
        <div class="mx-2"><%= render_slot(@fauna) %></div>
        <div class="mx-2"><%= render_slot(@danger) %></div>
      </div>
    </div>
    """
  end
end
