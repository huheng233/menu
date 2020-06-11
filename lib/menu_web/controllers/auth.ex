defmodule MenuWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias Menu.Accounts.User
  alias MenuWeb.Router.Helpers

  @doc """
  初始化选项
  """
  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(User, user_id)
    assign(conn, :current_user, user)
  end

  def login(conn, user) do
    conn
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

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
      |> redirect(to: Helpers.session_path(conn, :new))
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
      |> redirect(to: Helpers.user_path(conn, :show, conn.assigns.current_user))
      |> halt()
    end
  end
end
