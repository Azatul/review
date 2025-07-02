defmodule Review.Repo do
  use Ecto.Repo,
    otp_app: :review,
    adapter: Ecto.Adapters.Postgres
end
