defmodule MenuWeb.SessionController do
  use MenuWeb, :controller
  alias Menu.Repo
  alias Menu.Accounts.User
  alias MenuWeb.Auth

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    # 根据邮箱地址从数据库中查找用户
    user = Repo.get_by(User, email: email)

    cond do
      user && Comeonin.Bcrypt.checkpw(password, user.password_hash) ->
        conn
        |> put_flash(:info, "欢迎你")
        |> Auth.login(user)
        |> redirect(to: page_path(conn, :index))

      # 用户存在，但密码错误
      user ->
        conn
        |> put_flash(:error, "用户名或密码错误")
        |> render("new.html")

      # 其它
      true ->
        # 预防暴力破解
        Comeonin.Bcrypt.dummy_checkpw()

        conn
        |> put_flash(:error, "用户名或密码错误")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "退出成功")
    |> redirect(to: page_path(conn, :index))
  end
end
