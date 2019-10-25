defmodule TaksoWeb.SessionController do
  use TaksoWeb, :controller
  alias Takso.{Authentication, Repo}
  alias Takso.Accounts.User

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    user = Repo.get_by(User, username: username)
    case Authentication.check_credentials(user, password) do
      {:ok, _} ->
        conn
        |> Authentication.login(user)
        |> put_flash(:info, "Welcome #{username}")
        |> redirect(to: page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Bad credentials")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Takso.Authentication.logout()
    |> redirect(to: page_path(conn, :index))
  end
end
