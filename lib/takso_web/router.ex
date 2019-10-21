defmodule TaksoWeb.Router do
  use TaksoWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Takso.Authentication, repo: Takso.Repo)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", TaksoWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    resources("/users", UserController)
    get "/bookings/summary", BookingController, :summary
    resources("/bookings", BookingController)
    resources("/sessions", SessionController, only: [:new, :create, :delete])
  end

  # Other scopes may use custom stacks.
  # scope "/api", TaksoWeb do
  #   pipe_through :api
  # end
end
