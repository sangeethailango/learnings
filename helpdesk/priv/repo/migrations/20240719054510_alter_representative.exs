defmodule Helpdesk.Repo.Migrations.AlterRepresentative do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:representatives) do
      add :num, :bigint
    end
  end

  def down do
    alter table(:representatives) do
      remove :num
    end
  end
end