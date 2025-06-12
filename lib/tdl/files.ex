defmodule Tdl.Files do
  alias Tdl.{Repo, File, Folder}

  def create_file(attrs \\ %{}) do
    %Tdl.File{}
    |> Tdl.File.changeset(attrs)
    |> Tdl.Repo.insert()
  end

  def create_folder(attrs \\ %{}) do
    %Tdl.Folder{}
    |> Tdl.Folder.changeset(attrs)
    |> Repo.insert()
  end
end
