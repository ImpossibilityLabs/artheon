defmodule Artheon.Repo.Migrations.ArtworkArtist do
  use Ecto.Migration

  def change do
    alter table(:artworks) do
      add :artist_id, references(:artists)
    end
  end
end
