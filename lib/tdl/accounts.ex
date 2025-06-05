defmodule Tdl.Accounts do
  alias Tdl.Repo
  alias Tdl.User

  def get_user_by_username(username) do
    Repo.get_by(User, username: username)
  end

  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_user(username, password_input) do
    case Repo.get_by(Tdl.User, username: username) do
      %Tdl.User{password: hash} = user ->
        if Bcrypt.verify_pass(password_input, hash) do
          {:ok, user}
        else
          {:error, :unauthorized}
        end

      nil ->
        Bcrypt.no_user_verify()
        {:error, :not_found}
    end
  end
end
