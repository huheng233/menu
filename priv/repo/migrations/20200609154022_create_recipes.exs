defmodule Menu.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add(:name, :string)
      add(:title, :string)
      add(:season, :integer)
      add(:episode, :integer)
      add(:content, :text)
      add(:user_id, references(:users, on_delete: :delete_all))

      timestamps()
    end

    create(index(:recipes, [:user_id]))
  end
end
