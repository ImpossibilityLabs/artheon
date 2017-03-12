defmodule Artheon.ArtworkView do
  use Artheon.Web, :view

  def render("index.json", %{artworks: artworks}) do
    %{data: render_many(artworks, Artheon.ArtworkView, "artwork.json")}
  end

  def render("show.json", %{artwork: artwork}) do
    %{data: render_one(artwork, Artheon.ArtworkView, "artwork.json")}
  end

  def render("artwork.json", %{artwork: artwork}) do
    %{
      id: artwork.id,
      uid: artwork.uid,
      slug: artwork.slug,
      title: artwork.title,
      category: artwork.category,
      medium: artwork.medium,
      created_at: artwork.created_at,
      updated_at: artwork.updated_at,
      date: artwork.date,
      height: artwork.height,
      width: artwork.width,
      depth: artwork.depth,
      diameter: artwork.diameter,
      website: artwork.website,
      collecting_institution: artwork.collecting_institution,
      image_rights: artwork.image_rights,
      images: render_many(artwork.images, Artheon.ArtworkImageView, "artwork_image.json")
    }
  end
end
