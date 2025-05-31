defmodule TdlWeb.SessionController do
  use TdlWeb, :controller
  alias Tdl.Accounts

  def new(conn, _params) do
    render(conn, :new, layout: false)
  end

  def create(conn, %{"username" => username, "password" => password}) do
    case Accounts.authenticate_user(username, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Logged in successfully.")
        |> redirect(to: "/")

      {:error, _} ->
        conn
        |> put_flash(:error, "Invalid username or password")
        |> render(:new)
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/login")
  end
end
