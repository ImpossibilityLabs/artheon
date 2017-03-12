defmodule Artheon.Artwork.Command.Search do
  @moduledoc """
  Filter artworks by search and pagination params.
  """

  import Ecto.Query
  alias Artheon.Artwork
  alias Artheon.Repo
  
  @max_artworks_per_page "50"

  @doc false
  @spec execute(map() | nil) :: [%Artwork{}]
  def execute(nil), do: execute(%{})
  def execute(params) do
    search = Map.get(params, "search")
    limit = String.to_integer(Map.get(params, "limit", @max_artworks_per_page))
    offset = ((String.to_integer(Map.get(params, "page", "1")) - 1) * limit)

    query = from a in Artwork,
      limit: ^limit,
      offset: ^offset,
      preload: [:images]

    query = if search do
      from a in query,
        where: like(a.title, ^("%#{search}%"))
          or like(a.category, ^("%#{search}%"))
          or like(a.medium, ^("%#{search}%"))
          or like(a.date_str, ^("%#{search}%"))
    else
      query
    end

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
