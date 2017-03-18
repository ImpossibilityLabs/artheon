defmodule Artheon.Artwork.Command.Search do
  @moduledoc """
  Filter artworks by search and pagination params.
  """

  import Ecto.Query
  alias Artheon.Artist
  alias Artheon.Artwork
  alias Artheon.Repo
  
  @max_artworks_per_page "50"

  @doc false
  @spec execute(map() | nil) :: [%Artwork{}]
  def execute(nil), do: execute(%{})
  def execute(params) do
    search = Map.get(params, "search")
    artist = Map.get(params, "artist")
    limit = String.to_integer(Map.get(params, "limit", @max_artworks_per_page))
    offset = ((String.to_integer(Map.get(params, "page", "1")) - 1) * limit)

    query = from a in Artwork,
      join: ar in Artist, on: a.artist_id == ar.id,
      limit: ^limit,
      offset: ^offset,
      preload: [artist: ar],
      preload: [:images]

    query = if search do
      from a in query,
        where: fragment("MATCH (a0.`title`, a0.`medium`, a0.`category`, a0.`slug`) AGAINST (? IN NATURAL LANGUAGE MODE)", ^search)
          or like(a.date_str, ^("%#{search}%"))
    else
      query
    end

    query = if artist do
      from a in query,
        where: fragment("MATCH (a1.`name`, a1.`nationality`, a1.`hometown`, a1.`location`, a1.`slug`) AGAINST (? IN NATURAL LANGUAGE MODE)", ^artist)
    else
      query
    end
    IO.inspect(Ecto.Adapters.SQL.to_sql(:all, Repo, query))

    query = if Map.get(params, "public_domain") do
      from a in query,
        where: like(a.image_rights, "%Public Domain%")
    else
      query
    end

    query = if Map.get(params, "paintings_only") do
      from a in query,
        where: a.category == "Painting"
    else
      query
    end

    Repo.all(query)
  end
end
