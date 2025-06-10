defmodule Tdl.Files do
  alias Tdl.{Repo, File}

  def create_file(attrs \\ %{}) do
    %Tdl.File{}
    |> Tdl.File.changeset(attrs)
    |> Tdl.Repo.insert()
  end
end