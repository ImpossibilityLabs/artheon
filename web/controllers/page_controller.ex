defmodule Artheon.PageController do
  use Artheon.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
