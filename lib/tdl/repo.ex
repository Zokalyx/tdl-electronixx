defmodule Tdl.Repo do
  use Ecto.Repo,
    otp_app: :tdl,
    adapter: Ecto.Adapters.Postgres
end
