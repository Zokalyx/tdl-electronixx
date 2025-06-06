defmodule Tdl.Folder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "folders" do
    field :foldername, :string
    belongs_to :parent_folder, __MODULE__
    belongs_to :permission, YourApp.Permission

    has_many :subfolders, __MODULE__, foreign_key: :parent_folder_id
    has_many :files, YourApp.File

    timestamps()
  end

end
