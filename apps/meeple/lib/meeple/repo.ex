defmodule Meeple.Repo do
  use Ecto.Repo,
    otp_app: :meeple,
    adapter: Ecto.Adapters.Postgres
end
