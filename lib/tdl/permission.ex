defmodule Tdl.Permission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "permissions" do
    field(:permission_type, :string)
    belongs_to(:user, Tdl.User)

    timestamps()
  end

  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:permission_type, :user_id])
    |> validate_required([:permission_type, :user_id])
    |> validate_inclusion(:permission_type, ["Read", "Write"])
  end
end
