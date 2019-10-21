defmodule TaksoWeb.BookingController do
  use TaksoWeb, :controller
  import Ecto.Query, only: [from: 2]
  alias Takso.{Repo, Sales.Taxi, Sales.Booking}

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, _params) do
    query = from(t in Taxi, where: t.status == "available", select: t)
    available_taxis = Repo.all(query)

    case length(available_taxis) > 0 do
      true ->
        conn
        |> put_flash(:info, "Your taxi will arrive in 5 minutes")
        |> redirect(to: booking_path(conn, :new))

      _ ->
        conn
        |> put_flash(:info, "At present, there is no taxi available!")
        |> redirect(to: booking_path(conn, :new))
    end
  end
end
