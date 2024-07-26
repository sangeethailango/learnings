defmodule MessagingApp.Repo do
  use AshPostgres.Repo, otp_app: :messaging_app

  def installed_extensions do
    # Add extensions here, and the migration generator will install them.
    ["ash-functions"]
  end
end
