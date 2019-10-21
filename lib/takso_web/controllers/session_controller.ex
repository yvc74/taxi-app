defmodule TaksoWeb.SessionController do
  use TaksoWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => password}}) do
    case Takso.Authentication.check_credentials(conn, username, password, repo: Takso.Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome #{username}")
        |> redirect(to: page_path(conn, :index))

      {:error, _reason, conn} ->
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
