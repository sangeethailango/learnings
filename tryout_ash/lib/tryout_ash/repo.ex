defmodule TryoutAsh.Repo do
  use AshPostgres.Repo, otp_app: :tryout_ash

  def installed_extensions do
    ["ash-functions"]
  end
end
