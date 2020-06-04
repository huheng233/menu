defmodule Menu.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:username, :string)
    field(:password_hash, :string)

    timestamps()
  end

  @spec changeset(
          {map, map} | %{:__struct__ => atom, optional(atom) => any},
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
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
    |> validate_format(:email, ~r/@/, message: "邮箱格式错误")
    |> unique_constraint(:email, name: :users_lower_email_index, message: "邮箱已被人占用")
    |> validate_length(:password, min: 6, message: "密码最短 6 位")
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))

      _ ->
        changeset
    end
  end
end
