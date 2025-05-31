defmodule Tdl.Repo.Migrations.ModifyUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :middlename
      remove :surname
      remove :email
    end
    drop index(:users, name: :users_pkey)

  end
end
