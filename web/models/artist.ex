defmodule Artheon.Artist do
  use Artheon.Web, :model

  @gender_female 0
  @gender_male 1
  @gender_unknown 2

  schema "artists" do
    field :uid, :string
    field :name, :string
    field :slug, :string
    field :nationality, :string
    field :birthday, :integer
    field :gender, :integer
    field :hometown, :string
    field :location, :string
    field :created_at, Ecto.DateTime
    field :updated_at, Ecto.DateTime

    has_many :artworks, Artheon.Artwork
  end

  @editable_fields [
    :uid,
    :slug,
    :name,
    :nationality,
    :birthday,
    :gender,
    :hometown,
    :location,
    :created_at,
    :updated_at
  ]
  @required_fields [
    :uid,
    :slug,
    :name
  ]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct), do: changeset(struct, %{})
  def changeset(struct, %{
    "gender" => gender,
    "birthday" => birthday,
    "created_at" => created_at,
    "updated_at" => updated_at,
  } = params) when is_bitstring(gender) do
    artist_params = params
    |> Map.drop(["gender", "birthday", "created_at", "updated_at"])
    |> Map.put("gender", get_gender(gender))
    |> Map.put("birthday", parse_birthdate(birthday))
    |> Map.put("created_at", to_ecto_datetime(created_at))
    |> Map.put("updated_at", to_ecto_datetime(updated_at))
    changeset(struct, artist_params)
  end
  def changeset(struct, params) do
    struct
    |> cast(params, @editable_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:uid)
    |> unique_constraint(:slug)
  end


  @spec parse_birthdate(String.t) :: Integer
  defp parse_birthdate(date) when is_integer(date), do: date
  defp parse_birthdate(date) when byte_size(date) >= 4 do
    with [year] <- Regex.run(~r/\d{4}/, date) do
      String.to_integer(year)
    else
      _ ->
        nil
    end
  end
  defp parse_birthdate(_date), do: nil
  
  @spec get_gender(String.t) :: integer()
  defp get_gender("male"), do: @gender_male
  defp get_gender("female"), do: @gender_female
  defp get_gender(_), do: @gender_unknown
end
