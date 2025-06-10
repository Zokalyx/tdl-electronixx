defmodule Tdl.Files do
  alias Tdl.{Repo, File, Permission}

  def create_file(attrs \\ %{}) do
    Repo.transaction(fn ->
      case %File{}
          |> File.changeset(attrs)
          |> Repo.insert() do
        {:ok, file} ->
          # Create the permission
          permission_attrs = %{
            "permission_type" => "Write",
            "user_id" => attrs["user_id"]
          }

          case %Permission{}
              |> Permission.changeset(permission_attrs)
              |> Repo.insert() do
            {:ok, permission} ->
              case file
                  |> File.changeset(%{"permissions_id" => permission.id})
                  |> Repo.update() do
                {:ok, updated_file} -> updated_file
                {:error, changeset} -> Repo.rollback(changeset)
              end
            {:error, changeset} ->
              Repo.rollback(changeset)
          end

        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
  end
end