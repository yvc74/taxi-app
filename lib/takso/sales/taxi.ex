defmodule Takso.Sales.Taxi do
  use Ecto.Schema
  import Ecto.Changeset


  schema "taxis" do
    field :username, :string
    field :location, :string
    field :status, :string
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :location, :status])
  end
end
