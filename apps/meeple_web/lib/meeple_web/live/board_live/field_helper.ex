defmodule MeepleWeb.BoardLive.FieldHelper do
  def vegetation_image(:high_mountains), do: "high_mountains.svg"
  def vegetation_image(:mountains), do: "mountains.svg"
  def vegetation_image(:hills), do: "hills.svg"
  def vegetation_image(:woods), do: "woods.svg"
  def vegetation_image(:planes), do: "planes.svg"
  def vegetation_image(:swamps), do: "swamps.svg"
  def vegetation_image(:lake), do: "lake.svg"
  def vegetation_image(_any), do: "unknown.svg"

  def description(_any),
    do:
      "Uncharted territories lie ahead of you, full of new opportunities and maybe also full of danger."
end
