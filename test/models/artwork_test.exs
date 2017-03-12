defmodule Artheon.ArtworkTest do
  use Artheon.ModelCase

  alias Artheon.Artwork

  @valid_attrs %{category: "some content", collecting_institution: "some content", created_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, date: %{day: 17, month: 4, year: 2010}, depth: "120.5", diameter: "120.5", height: "120.5", image_rights: "some content", medium: "some content", slug: "some content", title: "some content", uid: "some content", updated_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, website: "some content", width: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Artwork.changeset(%Artwork{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Artwork.changeset(%Artwork{}, @invalid_attrs)
    refute changeset.valid?
  end
end
