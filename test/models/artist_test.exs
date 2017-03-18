defmodule Artheon.ArtistTest do
  use Artheon.ModelCase

  alias Artheon.Artist

  @valid_attrs %{birthday: 42, created_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, gender: "some content", hometown: "some content", location: "some content", name: "some content", nationality: "some content", slug: "some content", uid: "some content", updated_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Artist.changeset(%Artist{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Artist.changeset(%Artist{}, @invalid_attrs)
    refute changeset.valid?
  end
end
