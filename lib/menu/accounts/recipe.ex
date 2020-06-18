defmodule Menu.Accounts.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  alias Menu.Accounts.User

  schema "recipes" do
    field(:content, :string)
    field(:episode, :integer, default: 1)
    field(:name, :string)
    field(:season, :integer, default: 1)
    field(:title, :string)
    field(:url, :string)
    belongs_to(:user, User)
    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :title, :season, :episode, :content, :url])
    |> validate_required([:name, :title, :season, :episode, :content], message: "请填写")
    |> validate_number(:season, greater_than: 0, message: "请输入大于 0 的数字")
    |> validate_number(:episode, greater_than: 0, message: "请输入大于 0 的数字")
    |> validate_url(:url)
    |> foreign_key_constraint(:user_id)
  end

  defp validate_url(changeset, field, _opt \\ []) do
    validate_change(changeset, field, fn _, url ->
      case url |> String.to_charlist() |> :http_uri.parse() do
        {:ok, _} -> []
        {:error, _} -> [url: "url 错误"]
      end
    end)
  end
end
