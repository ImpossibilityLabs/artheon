defmodule Artheon.ArtworkImageControllerTest do
  use Artheon.ConnCase

  alias Artheon.ArtworkImage
  @valid_attrs %{url: "some content", version: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, artwork_image_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    artwork_image = Repo.insert! %ArtworkImage{}
    conn = get conn, artwork_image_path(conn, :show, artwork_image)
    assert json_response(conn, 200)["data"] == %{"id" => artwork_image.id,
      "version" => artwork_image.version,
      "url" => artwork_image.url,
      "artwork" => artwork_image.artwork}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, artwork_image_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, artwork_image_path(conn, :create), artwork_image: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(ArtworkImage, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, artwork_image_path(conn, :create), artwork_image: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    artwork_image = Repo.insert! %ArtworkImage{}
    conn = put conn, artwork_image_path(conn, :update, artwork_image), artwork_image: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ArtworkImage, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    artwork_image = Repo.insert! %ArtworkImage{}
    conn = put conn, artwork_image_path(conn, :update, artwork_image), artwork_image: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    artwork_image = Repo.insert! %ArtworkImage{}
    conn = delete conn, artwork_image_path(conn, :delete, artwork_image)
    assert response(conn, 204)
    refute Repo.get(ArtworkImage, artwork_image.id)
  end
end
