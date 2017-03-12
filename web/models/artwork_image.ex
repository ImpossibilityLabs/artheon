defmodule Artheon.ArtworkImage do
  use Artheon.Web, :model

  schema "artwork_images" do
    field :version, :string
    field :url, :string

    belongs_to :artwork, Artheon.Artwork

    timestamps()
  end

  @editable_fields [:version, :url, :artwork_id]
  @required_fields [:version, :url, :artwork_id]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @editable_fields)
    |> validate_required(@required_fields)
  end
end
