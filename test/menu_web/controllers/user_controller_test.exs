defmodule MenuWeb.UserControllerTest do
  use MenuWeb.ConnCase

  alias Menu.Accounts
  alias Menu.Repo
  alias Menu.Accounts.User

  @create_attrs %{email: "some@email", password: "somepassword", username: "someusername"}
  @update_attrs %{
    email: "someupdated@email",
    password: "someupdatedpassword",
    username: "updatedname"
  }
  @invalid_attrs %{email: nil, password: nil, username: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Users"
    end
  end

  describe "new user" do
    test "renders form", %{conn: conn} do
      conn = get(conn, user_path(conn, :new))
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "create user" do
    test "redirects to index when data is valid", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: @create_attrs)
      assert Repo.get_by(User, @create_attrs |> Map.delete(:password))
      assert redirected_to(conn) == page_path(conn, :index)
      conn = get(conn, user_path(conn, :index))
      assert html_response(conn, 200) =~ Map.get(@create_attrs, :username)
      assert html_response(conn, 200) =~ "退出"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, user_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User"
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "update user" do
    setup [:create_user]

    @tag update_user_valid: true
    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put(conn, user_path(conn, :update, user), user: @update_attrs)
      assert redirected_to(conn, 302) == user_path(conn, :show, user)

      conn = get(conn, user_path(conn, :show, user))
      assert html_response(conn, 200) =~ "someupdated@email"
    end

    @tag update_user_valid: false
    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, user_path(conn, :update, user), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, user_path(conn, :delete, user))
      assert redirected_to(conn) == user_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, user_path(conn, :show, user))
      end)
    end
  end

  describe "logouts user" do
    setup [:create_user]

    test "logouts user when logout button clicked", %{conn: conn, user: user} do
      login_params = Map.delete(@create_attrs, :username)
      login_path = session_path(conn, :create)
      conn = post(conn, login_path, session: login_params)
      conn = delete(conn, session_path(conn, :delete, user))
      assert get_flash(conn, :info) == "退出成功"
      assert redirected_to(conn) == page_path(conn, :index)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
