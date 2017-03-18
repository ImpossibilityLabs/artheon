defmodule Artheon.ArtistView do
  use Artheon.Web, :view

  def render("index.json", %{artists: artists}) do
    %{data: render_many(artists, Artheon.ArtistView, "artist.json")}
  end

  def render("show.json", %{artist: artist}) do
    %{data: render_one(artist, Artheon.ArtistView, "artist.json")}
  end

  def render("artist.json", %{artist: artist}) do
    %{id: artist.id,
      uid: artist.uid,
      name: artist.name,
      slug: artist.slug,
      nationality: artist.nationality,
      birthday: artist.birthday,
      gender: artist.gender,
      hometown: artist.hometown,
      location: artist.location,
      created_at: artist.created_at,
      updated_at: artist.updated_at}
  end
end
