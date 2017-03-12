defmodule Artheon.ArtworkController do
  use Artheon.Web, :controller

  alias Artheon.Artwork.Command.Search
  alias Artheon.Artwork

  def index(conn, params) do
    artworks = Search.execute(params)
    render(conn, "index.json", artworks: artworks)
  end

  def create(conn, %{"artwork" => artwork_params}) do
    changeset = Artwork.changeset(%Artwork{}, artwork_params)

    case Repo.insert(changeset) do
      {:ok, artwork} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", artwork_path(conn, :show, artwork))
        |> render("show.json", artwork: artwork)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Artheon.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    artwork = Repo.get!(Artwork, id)
    render(conn, "show.json", artwork: artwork)
  end

  def update(conn, %{"id" => id, "artwork" => artwork_params}) do
    artwork = Repo.get!(Artwork, id)
    changeset = Artwork.changeset(artwork, artwork_params)

    case Repo.update(changeset) do
      {:ok, artwork} ->
        render(conn, "show.json", artwork: artwork)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Artheon.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    artwork = Repo.get!(Artwork, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(artwork)

    send_resp(conn, :no_content, "")
  end
end
