defmodule MenuWeb.SessionControllerTest do
  use MenuWeb.ConnCase
  alias Menu.Repo
  alias Menu.Accounts.User

  @valid_user_attrs %{
    email: "chenxsan@gmail.com",
    username: "chenxsan",
    password: String.duplicate("a", 6)
  }

  test "renders form for new sessions", %{conn: conn} do
    conn = get(conn, session_path(conn, :new))
    # 200 响应，页面上带有“登录”
    assert html_response(conn, 200) =~ "登录"
  end

  test "login user and redirect to home page when data is valid", %{conn: conn} do
    user_changeset = User.changeset(%User{}, @valid_user_attrs)
    user = Repo.insert!(user_changeset)
    conn = post(conn, session_path(conn, :create), session: @valid_user_attrs)
    assert get_flash(conn, :info) == "欢迎你"
    assert redirected_to(conn) == page_path(conn, :index)
    # 读取首页，页面上包含已登录用户的用户名
    conn = get(conn, page_path(conn, :index))
    assert html_response(conn, 200) =~ Map.get(@valid_user_attrs, :username)
    # 读取用户页，页面上包含已登录用户的用户名
    conn = get(conn, user_path(conn, :show, user))
    assert html_response(conn, 200) =~ Map.get(@valid_user_attrs, :username)
  end

  test "redirect to session new when email exists but with wrong password", %{conn: conn} do
    user_changeset = User.changeset(%User{}, @valid_user_attrs)
    # 插入新用户
    Repo.insert!(user_changeset)
    # 用户登录
    conn = post(conn, session_path(conn, :create), session: %{@valid_user_attrs | password: ""})
    # 显示“用户名或密码错误”
    assert get_flash(conn, :error) == "用户名或密码错误"
    # 返回登录页
    assert html_response(conn, 200) =~ "登录"
  end

  test "redirect to session new when nobody login", %{conn: conn} do
    conn = post(conn, session_path(conn, :create), session: @valid_user_attrs)
    # 显示“用户名或密码错误”
    assert get_flash(conn, :error) == "用户名或密码错误"
    # 返回登录页
    assert html_response(conn, 200) =~ "登录"
  end
end
