defmodule MenuWeb.UserController do
  use MenuWeb, :controller

  plug(:login_require when action in [:index, :show, :edit, :update, :delete])
  plug(:self_require when action in [:show, :edit, :update])

  alias Menu.Accounts
  alias Menu.Accounts.User
  alias MenuWeb.Auth

  @doc """
  检查用户登录状态
  Returns `conn`
  """
  def login_require(conn, _opts) do
    if(conn.assigns.current_user) do
      conn
    else
      conn
      |> put_flash(:info, "请先登录")
      |> redirect(to: session_path(conn, :new))
      |> halt()
    end
  end

  @doc """
  检查用户是否授权访问动作

  Returns `conn`
  """
  def self_require(conn, _) do
    %{"id" => id} = conn.params

    if String.to_integer(id) == conn.assigns.current_user.id do
      conn
    else
      conn
      |> put_flash(:error, "禁止访问未授权页面")
      |> redirect(to: user_path(conn, :show, conn.assigns.current_user))
      |> halt()
    end
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> Auth.login(user)
        |> redirect(to: page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
