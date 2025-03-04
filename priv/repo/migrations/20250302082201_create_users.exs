defmodule Demo.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :display_name, :string
      add :role, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
