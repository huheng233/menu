defmodule Menu.Repo.Migrations.AlterUserUsernameIndex do
  use Ecto.Migration

  def change do
    # 移除旧索引
    drop(index(:users, [:username]))
    # 增加新索引
    create(unique_index(:users, ["lower(username)"]))
  end
end
