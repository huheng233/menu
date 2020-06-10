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
    |> cast(attrs, [:name, :title, :season, :episode, :content])
    |> validate_required([:name, :title, :season, :episode, :content])
  end
end
