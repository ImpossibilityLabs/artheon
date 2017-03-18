defmodule Artheon.Repo.Migrations.CreateArtist do
  use Ecto.Migration

  def change do
    create table(:artists) do
      add :uid, :string
      add :name, :string
      add :slug, :string
      add :nationality, :string
      add :birthday, :integer
      add :gender, :integer
      add :hometown, :string
      add :location, :string
      add :created_at, :naive_datetime
      add :updated_at, :naive_datetime
    end
    create unique_index(:artists, [:uid])
    create unique_index(:artists, [:slug])

  end
end
