defmodule Menu.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:password, :string)
    field(:username, :string)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:username, :email, :password], message: "请填写")
    |> validate_format(:username, ~r/^[a-zA-Z0-9]+$/, message: "用户名只允许使用英文字母、数字及下划线")
    |> validate_length(:username, min: 3, message: "用户名最短 3 位")
    |> validate_length(:username, max: 15, message: "用户名最长 15 位")
    |> validate_exclusion(:username, ~w(admin administrator), message: "系统保留，无法注册，请更换")
    |> unique_constraint(:username, name: :users_lower_username_index, message: "用户名已被人占用")
    |> unique_constraint(:email)
  end
end
