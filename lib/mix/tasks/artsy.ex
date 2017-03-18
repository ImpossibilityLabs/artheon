defmodule Mix.Tasks.Artsy do
  @moduledoc """
  CLI tool to load artworks from Artsy REST API
  """

  use Mix.Task
  require Logger
  alias Artheon.Artist
  alias Artheon.Artwork
  alias Artheon.ArtworkImage
  alias Artheon.Repo

  @doc """
  Generate general access JWT for account.
  """
  def run(["load"]) do
    Mix.Task.run("app.start", [])
    with {:ok, all, skipped, failed} <- next_artworks(0, 0, 0) do
      IO.puts "Importing of Artsy artwork was successfuly finished!"
      IO.puts "TOTAL ARTWORKS: #{all}"
      IO.puts "TOTAL IMPORTED: #{all - skipped - failed}"
      IO.puts "TOTAL FAILED: #{failed}"
      IO.puts "TOTAL SKIPPED: #{skipped}"
    else
      _ ->
        IO.puts "IMPORT HAS FINISHED!"
    end
  end


  @doc """
  Load and save next page of artworks.
  """
  @spec next_artworks(integer, integer, integer) :: {:ok, integer, integer, integer} | :error
  def next_artworks(all_count, skipped_count, failed_count) do
    with {:ok, %{"_embedded" => %{"artworks" => artworks}}} <- Artsy.artworks() do
      all = Enum.map(artworks, &save_artwork/1)
      skipped = Enum.filter(all, &(&1 === false))
      failed = Enum.filter(all, &(&1 === nil))
      next_artworks(
        length(all) + all_count,
        length(skipped) + skipped_count,
        length(failed) + failed_count
      )
    else
      response ->
        Logger.info fn() -> "Invalid response from Artsy #{inspect(response)}" end
        {:ok, all_count, skipped_count, failed_count}
    end
  end


  @doc """
  Save Artsy decoded JSON object to database.
  """
  @spec save_artwork(map()) :: %Artwork{} | nil
  def save_artwork(%{
    "id" => uid,
    "image_versions" => image_versions,
    "_links" => %{
      "image" => %{
        "href" => image_url
      }
    }
  } = params) do
    artwork_params = params
    |> Map.drop(["id", "image_versions", "_links"])
    |> Map.put("uid", uid)
    changeset = Artwork.changeset(%Artwork{}, artwork_params)

    with nil <- Repo.get_by(Artwork, uid: uid),
      {:ok, artist_response} <- Artsy.artists(:artwork, uid),
      %{id: artist_id} <- save_first_artist(artist_response),
      changeset = Artwork.changeset(changeset, %{"artist_id" => artist_id}),
      {:ok, %{id: artwork_id} = artwork} <- Repo.insert(changeset)
    do
      Enum.each image_versions, fn(image_version) ->
        changeset = ArtworkImage.changeset(%ArtworkImage{}, %{
          version: image_version,
          url: String.replace(image_url, "{image_version}", image_version),
          artwork_id: artwork_id
        })
        Repo.insert(changeset)
      end
      Logger.info fn() -> "Artwork #{uid} was saved to the database" end
      artwork
    else
      %Artwork{uid: artwork_id, artist_id: nil} = artwork ->
        with {:ok, artist_response} <- Artsy.artists(:artwork, artwork_id),
          %{id: artist_id} <- save_first_artist(artist_response)
        do
          changeset = Artwork.changeset(artwork, %{"artist_id" => artist_id})
          Repo.update(changeset)
          Logger.info fn() -> "Skipping artwork #{uid} (already in database), attaching artist" end
          false
        else
          _ ->
            false
        end
      %Artwork{} ->
        Logger.info fn() -> "Skipping artwork #{uid} (already in database)" end
        false
      {:error, changeset} ->
        Logger.warn fn() -> "Artwork #{uid} was not saved: #{inspect(changeset)}" end
        nil
      _ ->
        nil
    end
  end
  def save_artwork(_params), do: nil

  @doc """
  Save Artsy decoded JSON object to database.
  """
  @spec save_first_artist(map()) :: %Artist{} | nil
  def save_first_artist(%{"_embedded" => %{"artists" => []}}), do: nil
  def save_first_artist(%{"_embedded" => %{"artists" => [%{"id" => uid} = artist_params | _]}}) do
    artist_params = artist_params
    |> Map.drop(["id", "image_versions", "_links"])
    |> Map.put("uid", uid)
    changeset = Artist.changeset(%Artist{}, artist_params)

    with nil <- Repo.get_by(Artist, uid: uid),
      {:ok, artist} <- Repo.insert(changeset)
    do
      Logger.info fn() -> "Artist #{uid} was saved to the database" end
      artist
    else
      %Artist{} = artist ->
        Logger.info fn() -> "Skipping artist #{uid} (already in database)" end
        artist
      {:error, changeset} ->
        Logger.warn fn() -> "Artist #{uid} was not saved: #{inspect(changeset)}" end
        nil
      _ ->
        nil
    end
  end
end
