defmodule Takso.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add(:pickup_address, :string)
      add(:dropoff_address, :string)
      timestamps()
    end
  end
end
