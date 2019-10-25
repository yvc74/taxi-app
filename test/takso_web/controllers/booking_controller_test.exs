defmodule TaksoWeb.BookingControllerTest do
  use TaksoWeb.ConnCase

  alias Takso.{Repo, Guardian}
  alias Takso.Sales.{Taxi, Booking}

  setup do
    user = Repo.get!(User, 1)
    conn = build_conn()
           |> bypass_through(Takso.Router, [:browser, :browser_auth, :ensure_auth])
           |> get("/")
           |> Map.update!(:state, fn (_) -> :set end)
           |> Guardian.Plug.sign_in(user)
           |> send_resp(200, "Flush the session")
           |> recycle
    {:ok, conn: conn}
  end

  test "Booking rejection", %{conn: conn} do
    Repo.insert!(%Taxi{status: "busy"})

    conn =
      post(conn, "/bookings", %{
        booking: [pickup_address: "Liivi 2", dropoff_address: "Lõunakeskus"]
      })

    conn = get(conn, redirected_to(conn))
    assert html_response(conn, 200) =~ ~r/At present, there is no taxi available!/
  end

  test "Booking aceptance", %{conn: conn} do
    Repo.insert!(%Taxi{status: "available"})

    conn =
      post(conn, "/bookings", %{
        booking: [pickup_address: "Liivi 2", dropoff_address: "Lõunakeskus"]
      })

    conn = get(conn, redirected_to(conn))
    assert html_response(conn, 200) =~ ~r/Your taxi will arrive in \d+ minutes/
  end

  test "booking requires a 'pickup address'" do
    changeset = Booking.changeset(%Booking{}, %{pickup_address: nil, dropoff_address: "Liivi 2"})
    assert Keyword.has_key?(changeset.errors, :pickup_address)
  end

  test "booking requires different 'pickup address' and 'dropoff address'" do
    changeset =
      Booking.changeset(%Booking{}, %{pickup_address: "Liivi 2", dropoff_address: "Liivi 2"})

    assert Keyword.has_key?(changeset.errors, :same_address)
  end
end
