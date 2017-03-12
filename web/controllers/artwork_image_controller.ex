defmodule Artheon.ArtworkImageController do
  use Artheon.Web, :controller

  alias Artheon.ArtworkImage

  def index(conn, _params) do
    artwork_images = Repo.all(ArtworkImage)
    render(conn, "index.json", artwork_images: artwork_images)
  end

  def create(conn, %{"artwork_image" => artwork_image_params}) do
    changeset = ArtworkImage.changeset(%ArtworkImage{}, artwork_image_params)

    case Repo.insert(changeset) do
      {:ok, artwork_image} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", artwork_image_path(conn, :show, artwork_image))
        |> render("show.json", artwork_image: artwork_image)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Artheon.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    artwork_image = Repo.get!(ArtworkImage, id)
    render(conn, "show.json", artwork_image: artwork_image)
  end

  def update(conn, %{"id" => id, "artwork_image" => artwork_image_params}) do
    artwork_image = Repo.get!(ArtworkImage, id)
    changeset = ArtworkImage.changeset(artwork_image, artwork_image_params)

    case Repo.update(changeset) do
      {:ok, artwork_image} ->
        render(conn, "show.json", artwork_image: artwork_image)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Artheon.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    artwork_image = Repo.get!(ArtworkImage, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(artwork_image)

    send_resp(conn, :no_content, "")
  end
end
