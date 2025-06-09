defmodule TdlWeb.Plugs.Auth do
  import Plug.Conn
  alias Tdl.{Repo, User}

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    user =
      if user_id do
        Repo.get(User, user_id)
      else
        nil
      end

    assign(conn, :current_user, user)
  end
end
