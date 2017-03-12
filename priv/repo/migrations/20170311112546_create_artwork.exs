defmodule Artheon.Repo.Migrations.CreateArtwork do
  use Ecto.Migration

  def change do
    create table(:artworks) do
      add :uid, :string
      add :slug, :string
      add :title, :string
      add :category, :string
      add :medium, :string
      add :created_at, :naive_datetime
      add :updated_at, :naive_datetime
      add :date, :date
      add :date_str, :string
      add :height, :float
      add :width, :float
      add :depth, :float
      add :diameter, :float
      add :website, :string
      add :collecting_institution, :string
      add :image_rights, :string
    end
    create unique_index(:artworks, [:uid])
    create unique_index(:artworks, [:slug])

  end
end
