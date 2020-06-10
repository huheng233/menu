defmodule Menu.Accounts.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipes" do
    field(:content, :string)
    field(:episode, :integer, default: 1)
    field(:name, :string)
    field(:season, :integer, default: 1)
    field(:title, :string)
    field(:user_id, :id)

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :title, :season, :episode, :content, :user_id])
    |> validate_required([:name, :title, :season, :episode, :content, :user_id], message: "请填写")
    |> validate_number(:season, greater_than: 0, message: "请输入大于 0 的数字")
    |> validate_number(:episode, greater_than: 0, message: "请输入大于 0 的数字")
    |> foreign_key_constraint(:user_id, message: "用户不存在")
  end
end
