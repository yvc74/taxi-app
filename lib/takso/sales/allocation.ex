defmodule Takso.Sales.Allocation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "allocations" do
    field :status, :string
    belongs_to :booking, Takso.Sales.Booking
    belongs_to :taxi, Takso.Sales.Taxi

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status])
    |> validate_required([:status])
  end
end

