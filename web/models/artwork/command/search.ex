defmodule Artheon.Artwork.Command.Search do
  @moduledoc """
  Filter artworks by search and pagination params.
  """

  import Ecto.Query
  alias Artheon.Artwork
  alias Artheon.Repo
  
  @max_artworks_per_page "50"

  @doc false
  @spec execute(map()) :: [%Artwork{}]
  def execute(params) do
    search = Map.get(params, "search")
    limit = String.to_integer(Map.get(params, "limit", @max_artworks_per_page))
    offset = ((String.to_integer(Map.get(params, "page", "1")) - 1) * limit)

    query = if search do
      from a in Artwork,
        where: like(a.title, ^("%#{search}%"))
          or like(a.category, ^("%#{search}%"))
          or like(a.medium, ^("%#{search}%"))
          or like(a.date_str, ^("%#{search}%")),
        limit: ^limit,
        offset: ^offset,
        preload: [:images]
    else
      from a in Artwork,
      limit: ^limit,
      offset: ^offset,
      preload: [:images]
    end
    Repo.all(query)
  end
end
