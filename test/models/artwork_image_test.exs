defmodule Artheon.ArtworkImageTest do
  use Artheon.ModelCase

  alias Artheon.ArtworkImage

  @valid_attrs %{url: "some content", version: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ArtworkImage.changeset(%ArtworkImage{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ArtworkImage.changeset(%ArtworkImage{}, @invalid_attrs)
    refute changeset.valid?
  end
end
