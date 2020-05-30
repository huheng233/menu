defmodule Menu.UserTest do
  use Menu.ModelCase

  alias Menu.Accounts.User

  @valid_attrs %{email: "some@content.com", password: "some content", username: "some content"}
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
end
