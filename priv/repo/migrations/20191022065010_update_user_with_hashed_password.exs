defmodule Takso.Repo.Migrations.UpdateUserWithHashedPassword do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :hashed_password, :string
      remove :password
    end

    create unique_index(:users, [:username])
  end

end
