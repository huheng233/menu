defmodule MenuWeb.RecipeControllerTest do
  use MenuWeb.ConnCase

  alias Menu.Accounts.{User, Recipe}

  @user_attrs %{
    email: "chenxsan@mail.com",
    username: "chehgnx",
    password: String.duplicate("1", 6)
  }
  @another_user_attrs %{
    email: "sa666@gmail.com",
    username: "sa666",
    password: String.duplicate("1", 6)
  }

  @recipe_attrs %{
    content: "some content",
    episode: 42,
    name: "some name",
    season: 42,
    title: "some title"
  }
  @another_recipe_attrs %{
    content: "some updated content",
    episode: 43,
    name: "some updated name",
    season: 43,
    title: "some updated title"
  }
  @invalid_recipe_attrs %{content: nil, episode: nil, name: nil, season: nil, title: nil}

  setup %{conn: conn} = context do
    user = Repo.insert!(User.changeset(%User{}, @user_attrs))

    if context[:logged_in] == true do
      conn = post(conn, session_path(conn, :create), session: @user_attrs)
      {:ok, [conn: conn, user: user]}
    else
      :ok
    end
  end

  describe "index" do
    @tag logged_in: true
    test "lists all recipes", %{conn: conn} do
      conn = get(conn, recipe_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Recipes"
    end
  end

  describe "new recipe" do
    @tag logged_in: true
    test "renders form", %{conn: conn} do
      conn = get(conn, recipe_path(conn, :new))
      assert html_response(conn, 200) =~ "New Recipe"
    end
  end

  describe "create recipe" do
    @tag logged_in: true
    test "redirects to show when data is valid", %{conn: conn} do
      post(conn, recipe_path(conn, :create), recipe: @recipe_attrs)
      recipe = Repo.get_by(Recipe, @recipe_attrs)
      conn = get(conn, recipe_path(conn, :show, recipe.id))
      assert html_response(conn, 200) =~ "Show Recipe"
    end

    @tag logged_in: true
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, recipe_path(conn, :create), recipe: @invalid_recipe_attrs)
      assert html_response(conn, 200) =~ "New Recipe"
    end
  end

  describe "edit recipe" do
    @tag logged_in: true
    test "renders form for editing chosen recipe", %{conn: conn, user: user} do
      recipe = Repo.insert!(%Recipe{user_id: user.id})
      conn = get(conn, recipe_path(conn, :edit, recipe))
      assert html_response(conn, 200) =~ "Edit Recipe"
    end
  end

  describe "update recipe" do
    @tag logged_in: true
    test "redirects when data is valid", %{conn: conn, user: user} do
      recipe = Repo.insert!(%Recipe{user_id: user.id})
      conn = put(conn, recipe_path(conn, :update, recipe), recipe: @another_recipe_attrs)
      assert redirected_to(conn) == recipe_path(conn, :show, recipe)
      assert Repo.get_by(Recipe, @another_recipe_attrs)
      conn = get(conn, recipe_path(conn, :show, recipe))
      assert html_response(conn, 200) =~ @another_recipe_attrs.title
    end

    @tag logged_in: true
    test "renders errors when data is invalid", %{conn: conn, user: user} do
      recipe = Repo.insert!(%Recipe{user_id: user.id})
      conn = put(conn, recipe_path(conn, :update, recipe), recipe: @invalid_recipe_attrs)
      assert html_response(conn, 200) =~ "Edit Recipe"
    end
  end

  describe "delete recipe" do
    @tag logged_in: true
    test "deletes chosen recipe", %{conn: conn, user: user} do
      recipe = Repo.insert!(%Recipe{user_id: user.id})
      conn = delete(conn, recipe_path(conn, :delete, recipe))
      assert redirected_to(conn) == recipe_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, recipe_path(conn, :show, recipe))
      end)
    end
  end

  test "guest access user action redirected to login page", %{conn: conn} do
    recipe = Repo.insert!(%Recipe{})

    Enum.each(
      [
        get(conn, recipe_path(conn, :index)),
        get(conn, recipe_path(conn, :new)),
        post(conn, recipe_path(conn, :create), recipe: %{}),
        get(conn, recipe_path(conn, :show, recipe)),
        get(conn, recipe_path(conn, :edit, recipe)),
        put(conn, recipe_path(conn, :update, recipe), recipe: %{}),
        delete(conn, recipe_path(conn, :delete, recipe))
      ],
      fn conn ->
        assert redirected_to(conn) == session_path(conn, :new)
        assert conn.halted
      end
    )
  end

  @tag logged_in: true
  test "user should not allowed to show recipe of other people", %{conn: conn, user: user} do
    # 当前登录用户创建了一个菜谱
    conn = post(conn, recipe_path(conn, :create), recipe: @recipe_attrs)
    recipe_attrs = @recipe_attrs |> Map.put_new(:user_id, user.id)
    recipe = Repo.get_by(Recipe, recipe_attrs)

    # 新建一个用户
    User.changeset(%User{}, @another_user_attrs) |> Repo.insert!()

    # 登录新建的用户
    conn = post(conn, session_path(conn, :create), session: @another_user_attrs)

    # 读取前头的 recipe 失败，因为它不属于新用户所有
    assert_error_sent(404, fn ->
      get(conn, recipe_path(conn, :show, recipe))
    end)
  end
end
