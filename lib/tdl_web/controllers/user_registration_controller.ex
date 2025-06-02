defmodule TdlWeb.UserRegistrationController do
  use TdlWeb, :controller
  alias Tdl.{Repo, User}

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"username" => username, "password" => password}) do
    changeset =
      Ecto.Changeset.change(%User{}, %{
        username: username,
        password: Bcrypt.hash_pwd_salt(password)
      })

    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully. Please log in.")
        |> redirect(to: ~p"/login")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Failed to create user")
        |> render(:new)
    end
  end
end
