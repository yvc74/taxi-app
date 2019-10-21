defmodule Takso.Sales.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field(:pickup_address, :string)
    field(:dropoff_address, :string)
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:pickup_address, :dropoff_address])
    |> validate_required([:pickup_address, :dropoff_address])
    |> validate_different_addresses()
  end

  def validate_different_addresses(changeset) do
    validate_change(changeset, :dropoff_address, fn _, dropoff_address ->
      {_, pickup_address} = fetch_field(changeset, :pickup_address)

      case dropoff_address == pickup_address do
        true -> [{:same_address, "Dropoff address and pickup address must be different"}]
        false -> []
      end
    end)
  end
end
