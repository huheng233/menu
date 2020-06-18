defmodule Menu.Repo.Migrations.AddUrlToRecipe do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      add(:url, :string)
    end
  end
end
