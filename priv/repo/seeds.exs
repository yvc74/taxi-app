# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Takso.Repo.insert!(%Takso.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Takso.{Repo, Accounts.User, Sales.Taxi}

[%{name: "Fred Flintstone", username: "fred", password: "parool"},
 %{name: "Barney Rubble", username: "barney", password: "parool"}]
|> Enum.map(fn user_data -> User.changeset(%User{}, user_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)

# [%{username: "Brad Pitt", location: "Los Angeles", status: "available"},
#  %{username: "James McAvoy", location: "New York", status: "available"}]
# |> Enum.map(fn taxi_data -> Taxi.changeset(%Taxi{}, taxi_data) end)
# |> Enum.each(fn changeset -> Repo.insert!(changeset) end)

