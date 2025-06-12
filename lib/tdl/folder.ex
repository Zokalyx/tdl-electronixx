defmodule Tdl.Folder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "folders" do
    field(:foldername, :string)
    belongs_to(:parent_folder, __MODULE__)
    belongs_to(:permissions, Tdl.Permission)

    has_many(:subfolders, __MODULE__, foreign_key: :parent_folder_id)
    has_many(:files, Tdl.File, foreign_key: :parent_folder_id)

    timestamps()
  end

  def changeset(folder, attrs) do
    folder
    |> cast(attrs, [:foldername, :parent_folder_id])
    |> validate_required([:foldername])
  end
end
