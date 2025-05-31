defmodule Tdl.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:username, :string)
    field(:password, :string)

    # Virtual input field
    field(:password_plain, :string, virtual: true)
  end

  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password_plain])
    |> validate_required([:username, :password_plain])
    |> validate_length(:password_plain, min: 6)
    |> unique_constraint(:username)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    if pw = get_change(changeset, :password_plain) do
      hash = Bcrypt.hash_pwd_salt(pw)
      change(changeset, password: hash)
    else
      changeset
    end
  end
end
