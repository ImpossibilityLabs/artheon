defmodule Artheon.Models.Helpers do
  @moduledoc """
  Useful helpers for common model conversions.
  """

  @doc """
  Convert date from Artsy format to Ecto.DateTime.
  """
  @spec to_ecto_datetime(String.t) :: %Ecto.DateTime{}
  def to_ecto_datetime(artsy_date) do
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
