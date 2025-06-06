defmodule Tdl.Repo.Migrations.AddFilesFoldersAndPermissions do
  use Ecto.Migration

  def change do

    create table(:permissions) do
      add :permission_type, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create table(:folders) do
      add :foldername, :string
      add :parent_folder_id, references(:folders, on_delete: :nilify_all)
      add :permissions_id, references(:permissions, on_delete: :nilify_all)

      timestamps()
    end

    create table(:files) do
      add :filename, :string
      add :content, :text
      add :parent_folder_id, references(:folders, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
      add :permissions_id, references(:permissions, on_delete: :nilify_all)

      timestamps()
    end

  end
end
