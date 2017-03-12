defmodule Artheon.Artwork do
  use Artheon.Web, :model

  schema "artworks" do
    field :uid, :string
    field :slug, :string
    field :title, :string
    field :category, :string
    field :medium, :string
    field :created_at, Ecto.DateTime
    field :updated_at, Ecto.DateTime
    field :date, Ecto.Date
    field :date_str, :string
    field :height, :float
    field :width, :float
    field :depth, :float
    field :diameter, :float
    field :website, :string
    field :collecting_institution, :string
    field :image_rights, :string

    has_many :images, Artheon.ArtworkImage
  end

  @editable_fields [
    :uid,
    :slug,
    :title,
    :category,
    :medium,
    :created_at,
    :updated_at,
    :date,
    :date_str,
    :height,
    :width,
    :depth,
    :diameter,
    :website,
    :collecting_institution,
    :image_rights
  ]
  @required_fields [
    :uid,
    :slug,
    :title,
    :category,
    :height,
    :width
  ]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct), do: changeset(struct, %{})
  def changeset(struct, %{
    "title" => title,
    "slug" => slug,
    "dimensions" => %{
      "cm" => %{
        "depth" => depth,
        "diameter" => diameter,
        "height" => height,
        "width" => width
      }
    },
    "date" => date,
    "created_at" => created_at,
    "updated_at" => updated_at,
  } = params) do
    artwork_params = params
    |> Map.drop(["dimensions", "date", "created_at", "updated_at", "slug", "title"])
    |> Map.put("slug", String.slice(slug, 0, 255))
    |> Map.put("title", String.slice(title, 0, 255))
    |> Map.put("height", height)
    |> Map.put("width", width)
    |> Map.put("depth", depth)
    |> Map.put("diameter", diameter)
    |> Map.put("date", parse_date(date))
    |> Map.put("date_str", date)
    |> Map.put("created_at", to_ecto_datetime(created_at))
    |> Map.put("updated_at", to_ecto_datetime(updated_at))
    changeset(struct, artwork_params)
  end
  def changeset(struct, params) do
    struct
    |> cast(params, @editable_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:uid)
    |> unique_constraint(:slug)
  end


  @spec parse_date(String.t) :: %Ecto.Date{} 
  defp parse_date(date) when byte_size(date) >= 4 do
    with [year] <- Regex.run(~r/\d{4}/, date) do
      "#{year}-01-01"
    else
      _ ->
        nil
    end
  end
  defp parse_date(_date), do: nil

  @spec to_ecto_datetime(String.t) :: %Ecto.DateTime{}
  defp to_ecto_datetime(artsy_date) do
    with {:ok, artsy_date} <- DateTime.from_iso8601(artsy_date),
      ts when is_integer(ts) <- DateTime.to_unix(artsy_date),
      %Ecto.DateTime{} = ecto_date <- Ecto.DateTime.from_unix!(ts, :seconds)
    do
      ecto_date
    else
      _ ->
        nil
    end
  end
end
