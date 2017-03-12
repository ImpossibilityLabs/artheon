defmodule Artheon.ArtworkControllerTest do
  use Artheon.ConnCase

  alias Artheon.Artwork
  @valid_attrs %{category: "some content", collecting_institution: "some content", created_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, date: %{day: 17, month: 4, year: 2010}, depth: "120.5", diameter: "120.5", height: "120.5", image_rights: "some content", medium: "some content", slug: "some content", title: "some content", uid: "some content", updated_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, website: "some content", width: "120.5"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, artwork_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    artwork = Repo.insert! %Artwork{}
    conn = get conn, artwork_path(conn, :show, artwork)
    assert json_response(conn, 200)["data"] == %{"id" => artwork.id,
      "uid" => artwork.uid,
      "slug" => artwork.slug,
      "title" => artwork.title,
      "category" => artwork.category,
      "medium" => artwork.medium,
      "created_at" => artwork.created_at,
      "updated_at" => artwork.updated_at,
      "date" => artwork.date,
      "height" => artwork.height,
      "width" => artwork.width,
      "depth" => artwork.depth,
      "diameter" => artwork.diameter,
      "website" => artwork.website,
      "collecting_institution" => artwork.collecting_institution,
      "image_rights" => artwork.image_rights}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, artwork_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, artwork_path(conn, :create), artwork: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Artwork, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, artwork_path(conn, :create), artwork: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    artwork = Repo.insert! %Artwork{}
    conn = put conn, artwork_path(conn, :update, artwork), artwork: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Artwork, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    artwork = Repo.insert! %Artwork{}
    conn = put conn, artwork_path(conn, :update, artwork), artwork: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    artwork = Repo.insert! %Artwork{}
    conn = delete conn, artwork_path(conn, :delete, artwork)
    assert response(conn, 204)
    refute Repo.get(Artwork, artwork.id)
  end
end
