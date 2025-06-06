defmodule Tdl.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "permissions" do
    field :permission_type, :string
    belongs_to :user, YourApp.User

    timestamps()
  end

end
