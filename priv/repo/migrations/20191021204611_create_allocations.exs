defmodule Takso.Repo.Migrations.CreateAllocations do
  use Ecto.Migration

  def change do
    create table(:allocations) do
      add :status, :string
      add :booking_id, references(:bookings)
      add :taxi_id, references(:taxis)

      timestamps()
    end

    create unique_index(:allocations, [:booking_id, :taxi_id])
  end
end
