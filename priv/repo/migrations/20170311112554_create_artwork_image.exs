defmodule Artheon.Repo.Migrations.CreateArtworkImage do
  use Ecto.Migration

  def change do
    create table(:artwork_images) do
      add :version, :string
      add :url, :string
      add :artwork_id, references(:artworks, on_delete: :nothing)

      timestamps()
    end
    create index(:artwork_images, [:artwork_id])

  end
end
