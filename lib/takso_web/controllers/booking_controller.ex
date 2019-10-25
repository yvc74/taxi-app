defmodule TaksoWeb.BookingController do
  use TaksoWeb, :controller
  import Ecto.Query, only: [from: 2]
  alias Takso.{Authentication, Repo}
  alias Ecto.{Changeset, Multi}
  alias Takso.Sales.{Taxi, Booking, Allocation}

  def index(conn, _params) do
    bookings = Repo.all(from b in Booking, where: b.user_id == ^Takso.Authentication.load_current_user(@conn).id)
    render conn, "index.html", bookings: bookings
  end

  def new(conn, _params) do
    changeset = Booking.changeset(%Booking{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"booking" => booking_params}) do
    user = conn.assigns.current_user

    booking_struct = Ecto.build_assoc(user, :bookings, Enum.map(booking_params, fn({key, value}) -> {String.to_atom(key), value} end))
    changeset = Booking.changeset(booking_struct, %{})
                |> Changeset.put_change(:status, "open")

    booking = Repo.insert!(changeset)

    query = from(t in Taxi, where: t.status == "available", select: t)
    available_taxis = Repo.all(query)

    case length(available_taxis) > 0 do
      true ->  taxi = List.first(available_taxis)
                Multi.new
                |> Multi.insert(:allocation, Allocation.changeset(%Allocation{}, %{status: "accepted"}) |> Changeset.put_change(:booking_id, booking.id) |> Changeset.put_change(:taxi_id, taxi.id))
                |> Multi.update(:taxi, Taxi.changeset(taxi, %{}) |> Changeset.put_change(:status, "busy"))
                |> Multi.update(:booking, Booking.changeset(booking, %{}) |> Changeset.put_change(:status, "allocated"))
                |> Repo.transaction
                conn
                |> put_flash(:info, "Your taxi will arrive in 5 minutes")
                |> redirect(to: booking_path(conn, :index))

      _    -> Booking.changeset(booking) |> Changeset.put_change(:status, "rejected")
                |> Repo.update
                conn
                |> put_flash(:info, "At present, there is no taxi available!")
                |> redirect(to: booking_path(conn, :index))
    end
  end

  def summary(conn, _params) do
    query = from t in Taxi,
            join: a in Allocation, on: t.id == a.taxi_id,
            group_by: t.username,
            where: a.status == "accepted",
            select: {t.username, count(a.id)}
    render conn, "summary.html", tuples: Repo.all(query)
  end

end
