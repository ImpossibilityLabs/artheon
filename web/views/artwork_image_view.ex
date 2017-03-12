defmodule Artheon.ArtworkImageView do
  use Artheon.Web, :view

  def render("index.json", %{artwork_images: artwork_images}) do
    %{data: render_many(artwork_images, Artheon.ArtworkImageView, "artwork_image.json")}
  end

  def render("show.json", %{artwork_image: artwork_image}) do
    %{data: render_one(artwork_image, Artheon.ArtworkImageView, "artwork_image.json")}
  end

  def render("artwork_image.json", %{artwork_image: artwork_image}) do
    %{id: artwork_image.id,
      version: artwork_image.version,
      url: artwork_image.url,
      artwork_id: artwork_image.artwork_id}
  end
end
