defmodule Tdl.Repo.Migrations.RemoveNameAddUserName do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :name
      add :username, :string, null: false
      add :password, :string, null: false
    end
    create unique_index(:users, [:username])
  end
end
