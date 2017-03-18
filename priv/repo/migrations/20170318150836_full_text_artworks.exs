defmodule Artheon.Repo.Migrations.FullTextArtworks do
  use Ecto.Migration

  def change do
    execute "CREATE FULLTEXT INDEX fulltext_artwork ON artworks(title, medium, category, slug);"
    execute "CREATE FULLTEXT INDEX fulltext_artist ON artists(name, nationality, hometown, location, slug);"
  end
end
