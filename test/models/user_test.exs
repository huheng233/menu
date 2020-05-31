defmodule Menu.UserTest do
  use Menu.ModelCase

  alias Menu.Accounts.User

  @valid_attrs %{email: "some@content.com", password: "some content", username: "somecontent"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "username should not be blank" do
    attrs = %{@valid_attrs | username: ""}
    assert {:username, "请填写"} in errors_on(%User{}, attrs)
  end

  test "username should be unique" do
    # 在测试数据库中插入新用户
    user_changeset = User.changeset(%User{}, @valid_attrs)
    Menu.Repo.insert!(user_changeset)

    # 尝试插入同名用户，应报告错误
    assert {:error, changeset} =
             Menu.Repo.insert(
               User.changeset(%User{}, %{@valid_attrs | email: "chenxsan+1@gmail.com"})
             )

    # 错误信息为“用户名已被人占用”
    assert {:username, "用户名已被人占用"} in errors_on(changeset)
  end

  test "username should be case insensitive" do
    changeset = User.changeset(%User{}, @valid_attrs)
    Menu.Repo.insert!(changeset)

    changeset2 =
      User.changeset(%User{}, %{
        @valid_attrs
        | username: "Somecontent",
          email: "chenxsan+1@gmail.com"
      })

    assert {:error, changeset3} = Menu.Repo.insert(changeset2)
    assert {:username, "用户名已被人占用"} in errors_on(changeset3)
  end

  test "username should only contains [a-zA-Z0-9_]" do
    attrs = %{@valid_attrs | username: "张三阿"}
    changeset = User.changeset(%User{}, attrs)
    refute changeset.valid?
  end

  test "changeset with invalid username should throw errors" do
    attrs = %{@valid_attrs | username: "李四"}
    assert {:username, "用户名只允许使用英文字母、数字及下划线"} in errors_on(%User{}, attrs)
  end

  test "username's length should be larger than 3" do
    attrs = %{@valid_attrs | username: "aa"}
    changeset = User.changeset(%User{}, attrs)
    assert {:username, "用户名最短 3 位"} in errors_on(changeset)
  end

  test "username's length should be less than 15" do
    attrs = %{@valid_attrs | username: String.duplicate("a", 16)}
    changeset = User.changeset(%User{}, attrs)
    assert {:username, "用户名最长 15 位"} in errors_on(changeset)
  end

  test "username should not be admin or administrator" do
    assert {:username, "系统保留，无法注册，请更换"} in errors_on(%User{}, %{@valid_attrs | username: "admin"})

    assert {:username, "系统保留，无法注册，请更换"} in errors_on(%User{}, %{
             @valid_attrs
             | username: "administrator"
           })
  end

  test "email should not be blank" do
    assert {:email, "请填写"} in errors_on(%User{}, %{@valid_attrs | email: ""})
  end

  test "email should contain @" do
    assert {:email, "邮箱格式错误"} in errors_on(%User{}, %{@valid_attrs | email: "abc"})
  end

  test "email should be unique" do
    Menu.Repo.insert!(User.changeset(%User{}, @valid_attrs))
    changeset = User.changeset(%User{}, %{@valid_attrs | username: "haha"})
    assert {:error, err_changeset} = Menu.Repo.insert(changeset)
    assert {:email, "邮箱已被人占用"} in errors_on(err_changeset)
  end

  test "email should be case insensitive" do
    Menu.Repo.insert!(User.changeset(%User{}, @valid_attrs))
    attrs = %{@valid_attrs | username: "haha", email: "Some@content.com"}
    changeset = User.changeset(%User{}, attrs)
    assert {:error, err_changeset} = Menu.Repo.insert(changeset)
    assert {:email, "邮箱已被人占用"} in errors_on(err_changeset)
  end

  test "password is required" do
    attrs = %{@valid_attrs | password: ""}
    assert {:password, "请填写"} in errors_on(%User{}, attrs)
  end

  test "password's length should be larger than 6" do
    attrs = %{@valid_attrs | password: String.duplicate("1", 5)}
    assert {:password, "密码最短 6 位"} in errors_on(%User{}, attrs)
  end

  test "password should be hashed" do
    %{changes: changes} = User.changeset(%User{}, @valid_attrs)
    assert Comeonin.Bcrypt.checkpw(changes.password, changes.password_hash)
  end
end
