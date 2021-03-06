defmodule Artheon.Router do
  use Artheon.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Artheon do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Artheon do
    pipe_through :api

    resources "/artists", ArtistController, except: [:new, :edit]
    resources "/artworks", ArtworkController, except: [:new, :edit]
    resources "/artwork_images", ArtworkImageController, except: [:new, :edit]
  end
end
